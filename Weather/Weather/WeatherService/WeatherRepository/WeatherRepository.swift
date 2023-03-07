//
//  WeatherRepository.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

struct WeatherRepository : WeatherRepositoryProtocol {
  
  private let TAG = "WeatherRepository"

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
  }
  
  // city, state and country
  func fetchWeather(forCity city: String,
             state: String,
             country: String,
                    completion: @escaping WeatherRepositoryCompletionResponse) {
    
    Log.verbose(TAG,"fetch weather called for -\(city), \(state) - \(country)")
    
    // fetch from network, update data store and notify caller
    networkLoader.query(forCity: city, state: state, country: country) { result in
      switch (result) {
      case .success(let response):
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
