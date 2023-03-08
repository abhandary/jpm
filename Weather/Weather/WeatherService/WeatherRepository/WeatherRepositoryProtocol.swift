//
//  WeatherRepositoryProtocol.swift
//  Weather
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

struct WeatherGeoCoordinatesParams : Codable {
  let lat: Double
  let lon: Double
}

struct WeatherGeocodingSearchParams : Codable {
  let city: String
  let state: String
  let country: String
}

typealias WeatherRepositoryCompletionResponse = (Result<WeatherResponse, WeatherRepositoryError>) -> Void

protocol WeatherRepositoryProtocol {
  
  // load last search
  func loadLastSearch(completion: @escaping WeatherRepositoryCompletionResponse)
  
  // city, state and country
  func fetchWeather(searchParams: WeatherGeocodingSearchParams,
             completion: @escaping WeatherRepositoryCompletionResponse)
  
  // geo coordinates search
  func fetchWeather(searchParams: WeatherGeoCoordinatesParams,
             completion: @escaping WeatherRepositoryCompletionResponse)
}
