//
//  WeatherStorageLoaderProtocol.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import Foundation

enum WeatherStorageError : Error {
  case fileURLError
  case fileMissingError
  case fileDecodingError
  case fileReadError
}

protocol WeatherStorageLoaderProtocol {
  func isLastSearchWeatherResponseStored() -> Bool
  func getStoredLastSearchWeatherRespons() -> Result<WeatherResponse, WeatherStorageError>
  func storeLastSearch(weatherResponse: WeatherResponse)
}
