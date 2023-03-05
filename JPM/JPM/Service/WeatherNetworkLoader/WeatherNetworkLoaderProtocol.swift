//
//  WeatherNetworkLoaderProtocol.swift
//  JPM
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

enum WeatherNetworkError: Error {
  case unknown
  case noData
  case badURL
  case networkError
  case decodingError
}

protocol WeatherNetworkLoaderProtocol {
  
  // city
  func query(forCity city: String, completion: @escaping WeatherNetworkLoaderCompletionResponse)
  
  // city & country
  func query(forCity city: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse)
  
  // city, state and country
  func query(forCity city: String,
             state: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse)
}
