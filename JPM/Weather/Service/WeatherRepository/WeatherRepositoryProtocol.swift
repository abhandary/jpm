//
//  WeatherRepositoryProtocol.swift
//  JPM
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

enum WeatherRepositoryError: Error {
  case noNetworkData
  case badURL
  case networkError
  case networkDecodingError
}

typealias WeatherRepositoryCompletionResponse = (Result<WeatherResponse, WeatherRepositoryError>) -> Void

protocol WeatherRepositoryProtocol {
  
  // load last search
  func loadLastSearch(completion: @escaping WeatherRepositoryCompletionResponse)
  
  // city, state and country
  func fetchWeather(forCity city: String,
             state: String,
             country: String,
             completion: @escaping WeatherRepositoryCompletionResponse)
}
