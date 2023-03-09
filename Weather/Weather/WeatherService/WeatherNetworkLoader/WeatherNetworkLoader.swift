//
//  WeatherNetworkLoader.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

private let TAG = "WeatherNetworkLoader"

// placeholders for query params.
enum WeatherAPIParams : String {
  case city = "{city}"
  case state = "{state}"
  case country = "{country}"
  case lat = "{lat}"
  case lon = "{lon}"
}

enum WeatherAPI {
  case geoCoding
  case geoCoordinates
  
  static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
  static let apiKey = "3f35a564a722135d492c56eb1e2a2f85"
}


// provides type safe end points and helper methods
extension WeatherAPI: EndPoint {
  func path() -> String {
    switch self {
    case .geoCoding:
      return "\(WeatherAPI.baseURL)q=\(WeatherAPIParams.city.rawValue),\(WeatherAPIParams.state.rawValue),\(WeatherAPIParams.country.rawValue)&appid=\(WeatherAPI.apiKey)&units=imperial"
    case .geoCoordinates:
      return "\(WeatherAPI.baseURL)lat=\(WeatherAPIParams.lat.rawValue)&lon=\(WeatherAPIParams.lon.rawValue)&appid=\(WeatherAPI.apiKey)&units=imperial"
    }
  }
  
  // for requests that don't have any params
  func request() -> URLRequest? {
    guard let url = URL(string: path()) else { return nil }
    return URLRequest(url: url)
  }
  
  // for requests with params
  func request(args: [String:String]) -> URLRequest? {
    var endPoint = path()
    for key in args.keys {
      guard let value = args[key] else { continue }
      guard let value = value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
        Log.error(TAG, "unable to escape value - \(value)")
        return nil
      }
      endPoint = endPoint.replacingOccurrences(of: key, with: value)
    }
    
    guard let url = URL(string: endPoint) else {
      Log.error(TAG, "unable to form URL")
      return nil
    }
    return URLRequest(url: url)
  }
}

struct WeatherNetworkLoader: WeatherNetworkLoaderProtocol {
  
  private var session: NetworkSessionProtocol
  private var decoder: DecoderProtocol
  
  init(session: NetworkSessionProtocol = URLSession.shared,
       decoder: DecoderProtocol = CustomJSONDecoder()) {
    self.session = session
    self.decoder = decoder
  }
  
  // MARK: - public methods
  
  // geo-coding weather query
  func query(forCity city: String,
             state: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    let params = [
      WeatherAPIParams.city.rawValue : city,
      WeatherAPIParams.state.rawValue : state,
      WeatherAPIParams.country.rawValue : country
    ]
    guard let endPoint = WeatherAPI.geoCoding.request(args: params) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }
  
  // geo-coordinates weather query
  func query(forLat lat: Double, lon: Double, completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    let params = [
      WeatherAPIParams.lat.rawValue : String(lat),
      WeatherAPIParams.lon.rawValue : String(lon),
    ]
    guard let endPoint = WeatherAPI.geoCoordinates.request(args: params) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }
  
  // MARK: - private methods
 
  private func queryAndDecode(forEndPoint endPoint: URLRequest,
                              completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    
    // load from network and decode response and generate a WeatherResponse if succesfull
    session.loadData(from: endPoint) { result in
      
      switch (result) {
      case .success(let data):
        if let weatherResponse = self.decoder.decode(type: WeatherResponse.self, from: data) {
          completion(.success(weatherResponse))
        } else {
          completion(.failure(.decodingError))
        }
      case .failure(let error):
        Log.error(TAG, "query: got an error - \(error)")
        completion(.failure(.networkError))
      }
    }
  }
}
