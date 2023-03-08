//
//  WeatherRepository.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

struct WeatherRepository : WeatherRepositoryProtocol {
  
  private let TAG = "WeatherRepository"
  private static let defaultSearch
    = WeatherGeocodingSearchParams(city: "New York", state: "NY", country: "USA")

  let networkLoader: WeatherNetworkLoaderProtocol
  let storageLoader: WeatherStorageLoaderProtocol

  init(networkLoader: WeatherNetworkLoaderProtocol,
       storageLoader: WeatherStorageLoaderProtocol) {
    self.networkLoader = networkLoader
    self.storageLoader = storageLoader
  }
  
  // load last search
  func loadLastSearch(completion: @escaping WeatherRepositoryCompletionResponse) {
    Log.verbose(TAG, "\(#function) called")
    if storageLoader.isLastSearchWeatherResponseStored() {
      // get stored search response and return
      let weatherResponseResult = storageLoader.getStoredLastSearchWeatherResponse()
      switch (weatherResponseResult) {
      case .success(let response):
        completion(.success(response))
      case .failure(let error):
        Log.error(TAG, error)
      }
      
      // get stored search params and use it to make a query
      let weatherSearchParamsResult = storageLoader.getStoredLastSearchWeatherSearchParams()
      switch (weatherSearchParamsResult) {
      case .success(let params):
        if let geocoding = params.geoCoding {
          self.fetchWeather(searchParams: geocoding, completion: completion)
          return
        }
        if let geocoordinates = params.geoCoordinates {
          self.fetchWeather(searchParams: geocoordinates, completion: completion)
          return
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
    // fallback to default search, if unable to retrieve stored search
    self.fetchWeather(searchParams: WeatherRepository.defaultSearch,
                      completion: completion)
  }
  
  // city, state and country
  func fetchWeather(searchParams: WeatherGeocodingSearchParams,
                    completion: @escaping WeatherRepositoryCompletionResponse) {
    
    Log.verbose(TAG,"fetch weather called for -\(searchParams)")
    
    // fetch from network, update data store and notify caller
    networkLoader.query(forCity: searchParams.city,
                        state: searchParams.state, country:
                          searchParams.country) { result in
      switch (result) {
      case .success(let response):
        let paramsToStore = WeatherSearchParams(geoCoding: searchParams, geoCoordinates: nil)
        self.storageLoader.storeLastSearch(params: paramsToStore)
        self.storageLoader.storeLastSearch(weatherResponse: response)
        completion(.success(response))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(WeatherRepository.map(networkError: error)))
      }
    }
  }
  
  func fetchWeather(searchParams: WeatherGeoCoordinatesParams,
                    completion: @escaping WeatherRepositoryCompletionResponse) {
    Log.verbose(TAG,"fetch weather called for -\(searchParams)")
    
    // fetch from network, update data store and notify caller
    networkLoader.query(forLat: searchParams.lat,
                        lon: searchParams.lon) { result in
      switch (result) {
      case .success(let response):
        let paramsToStore = WeatherSearchParams(geoCoding: nil, geoCoordinates: searchParams)
        self.storageLoader.storeLastSearch(params: paramsToStore)
        self.storageLoader.storeLastSearch(weatherResponse: response)
        completion(.success(response))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(WeatherRepository.map(networkError: error)))
      }
    }
  }
  
  private static func map(networkError: WeatherNetworkError) -> WeatherRepositoryError {
    switch (networkError) {
    case .noData:
      return .noNetworkData
    case .badURL:
      return .badURL
    case .networkError:
      return .networkError
    case .decodingError:
      return .networkDecodingError
    }
  }
}
