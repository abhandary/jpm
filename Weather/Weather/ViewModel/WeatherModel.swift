//
//  Weather.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation

struct WeatherSummary {
  let condition: String
  let conditionDescription: String
  let conditionIcon: String
  let temp: Double
  let tempMin: Double
  let tempMax: Double
}

struct WeatherDetails {
  let feelsLike: Double
  let humidity: Int
  let pressure: Int
}

enum WindDirection {
  case north
  case south
  case east
  case west
  case northwest
  case northeast
  case southeast
  case southwest
}

struct WindModel {
  let speed: Double
  let direction: WindDirection
  let gust: Int
}

enum PrecipitationCondition {
  case rain
  case snow
}

struct Precipitation {
  let condition: PrecipitationCondition
  let inches: Double
}

struct Sun {
  let sunrise: Date
  let sunset: Date
}

struct WeatherModel {
  let cityName: String
  let summary: WeatherSummary
  let details: WeatherDetails
  let wind: WindModel
  let precipitation: Precipitation?
  let sun: Sun
}
