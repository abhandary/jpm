//
//  WeatherNetworkLoaderProtocol.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

enum WeatherNetworkError: Error {
  case noData
  case badURL
  case networkError
  case decodingError
}

typealias WeatherNetworkLoaderCompletionResponse = (Result<WeatherResponse, WeatherNetworkError>) -> Void

protocol WeatherNetworkLoaderProtocol {
  
  // geo coding query
  func query(forCity city: String,
             state: String,
             country: String,
             completion: @escaping WeatherNetworkLoaderCompletionResponse)
  
  // geo co-ordinates query
  func query(forLat lat: Double, lon: Double, completion: @escaping WeatherNetworkLoaderCompletionResponse)
}
