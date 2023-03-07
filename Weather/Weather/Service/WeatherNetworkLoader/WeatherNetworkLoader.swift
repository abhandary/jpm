//
//  WeatherNetworkLoader.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

private let TAG = "WeatherNetworkLoader"

enum WeatherAPI {
  case city
  case cityWithCountry
  case cityWithStateAndCountry
  case geoCoordinates
  
  static let baseGeocodingURL = "https://api.openweathermap.org/data/2.5/weather?q="
  static let baseGeocoordinatesURL = "https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s"
  static let apiKey = "3f35a564a722135d492c56eb1e2a2f85"
}

extension WeatherAPI: EndPoint {
  func path() -> String {
    switch self {
    case .city:
      return "\(WeatherAPI.baseGeocodingURL)%s&appid=\(WeatherAPI.apiKey)"
    case .cityWithCountry:
      return "\(WeatherAPI.baseGeocodingURL)$s,%s&appid=\(WeatherAPI.apiKey)"
    case .cityWithStateAndCountry:
      return "\(WeatherAPI.baseGeocodingURL)%s,%s,%s&appid=\(WeatherAPI.apiKey)"
    case .geoCoordinates:
      return "\(WeatherAPI.baseGeocoordinatesURL)&appid=\(WeatherAPI.apiKey)"
    }
  }
  
  func request() -> URLRequest? {
    guard let url = URL(string: path()) else { return nil }
    return URLRequest(url: url)
  }
  
  func request(args: [CVarArg]) -> URLRequest? {
    let endPoint = String(format: path(), arguments: args)
    guard let url = URL(string: endPoint) else { return nil }
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
  func query(forCity city: String, completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    guard let endPoint = WeatherAPI.city.request(args: [city]) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }

  func query(forCity city: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    guard let endPoint = WeatherAPI.cityWithCountry.request(args: [city, country]) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }
  
  func query(forCity city: String,
             state: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    guard let endPoint = WeatherAPI.cityWithStateAndCountry.request(args: [city, state, country]) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }
  
  func query(forLat lat: Double, lon: Double, completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    guard let endPoint = WeatherAPI.geoCoordinates.request(args: [lat, lon]) else {
      completion(.failure(.badURL))
      return
    }
    Log.verbose(TAG, "querying weather with endpoint - \(endPoint)")
    
    queryAndDecode(forEndPoint: endPoint, completion: completion)
  }
  
  // MARK: - private methods
 
  private func queryAndDecode(forEndPoint endPoint: URLRequest,
                              completion: @escaping WeatherNetworkLoaderCompletionResponse) {
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
