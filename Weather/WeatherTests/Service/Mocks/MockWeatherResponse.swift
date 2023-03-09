//
//  MockWeatherResponse.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockWeatherResponse {
  static let json = #"""
      {
        "coord": {
          "lon": -73.9866,
          "lat": 40.7306
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 32.99,
          "feels_like": 22.48,
          "temp_min": 30.09,
          "temp_max": 35.22,
          "pressure": 1018,
          "humidity": 54
        },
        "visibility": 10000,
        "wind": {
          "speed": 16.11,
          "deg": 340,
          "gust": 26.46
        },
        "clouds": {
          "all": 75
        },
        "dt": 1678255637,
        "sys": {
          "type": 2,
          "id": 2039034,
          "country": "US",
          "sunrise": 1678274372,
          "sunset": 1678316058
        },
        "timezone": -18000,
        "id": 5128581,
        "name": "New York",
        "cod": 200
      }
      """#
  
  static let mockNewYorkJsonData: Data = MockWeatherResponse.json.data(using: .utf8)!
  static let mockNewYorkWeatherResponse = CustomJSONDecoder().decode(type: WeatherResponse.self, from: mockNewYorkJsonData)
}

