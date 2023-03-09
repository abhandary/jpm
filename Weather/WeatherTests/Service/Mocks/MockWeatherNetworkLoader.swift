//
//  MockWeatherNetworkLoader.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockWeatherNetworkLoader : WeatherNetworkLoaderProtocol {
  
  var result: Result<WeatherResponse, WeatherNetworkError>
  
  func query(forCity city: String,
             state: String,
             country: String, completion: @escaping WeatherNetworkLoaderCompletionResponse) {
    completion(result)
  }
  
  func query(forLat lat: Double, lon: Double, completion: @escaping WeatherNetworkLoaderCompletionResponse) {
      completion(result)
  }
}
