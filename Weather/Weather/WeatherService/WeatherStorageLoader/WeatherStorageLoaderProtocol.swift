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

struct WeatherSearchParams : Codable {
  let geoCoding: WeatherGeocodingSearchParams?
  let geoCoordinates: WeatherGeoCoordinatesParams?
}

protocol WeatherStorageLoaderProtocol {
  // check if there is a weather response stored
  func isLastSearchWeatherResponseStored() -> Bool
  
  // get the last stored wether response
  func getStoredLastSearchWeatherResponse() -> Result<WeatherResponse, WeatherStorageError>
  
  // get the last stored search params
  func getStoredLastSearchWeatherSearchParams() -> Result<WeatherSearchParams, WeatherStorageError>
  
  // store the last search params
  func storeLastSearch(params: WeatherSearchParams)
  
  // store the last search response
  func storeLastSearch(weatherResponse: WeatherResponse)
}
