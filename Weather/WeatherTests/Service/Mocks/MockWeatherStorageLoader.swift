//
//  MockWeatherStorageLoader.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockWeatherStorageLoader : WeatherStorageLoaderProtocol {
  
  var isLastSearchWeatherResponseStoredResponse : Bool
  var lastSearchWeatherResponse: Result<WeatherResponse, WeatherStorageError>
  var storedLastSearchWeatherSearchParamsResponse: Result<WeatherSearchParams, WeatherStorageError>
  
  init() {
    isLastSearchWeatherResponseStoredResponse = false
    lastSearchWeatherResponse = .failure(.fileMissingError)
    storedLastSearchWeatherSearchParamsResponse = .failure(.fileMissingError)
  }
  
  func isLastSearchWeatherResponseStored() -> Bool {
    return isLastSearchWeatherResponseStoredResponse
  }
  
  func getStoredLastSearchWeatherResponse() -> Result<WeatherResponse, WeatherStorageError> {
    return lastSearchWeatherResponse
  }
  
  func getStoredLastSearchWeatherSearchParams() -> Result<WeatherSearchParams, WeatherStorageError> {
    return storedLastSearchWeatherSearchParamsResponse
  }
  
  func storeLastSearch(params: WeatherSearchParams) {
      // no-op
  }
  
  func storeLastSearch(weatherResponse: WeatherResponse) {
    // no-op
  }
}
