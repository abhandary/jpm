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
  let conditionIcon: URL?
  
  private static let iconURL = "https://openweathermap.org/img/wn/"
  
  static func from(weatherResponse: WeatherResponse) -> WeatherSummary? {
    var summary: WeatherSummary? = nil
    if let weather = weatherResponse.weather.first {
      let urlString = iconURL + weather.icon + "@2x.png"
      let url = URL(string: urlString)
      summary = WeatherSummary(condition: weather.main,
                               conditionDescription: weather.weatherDescription,
                               conditionIcon: url)
    }
    return summary
  }
}

struct WeatherTemperature {
  let temp: Int
  let tempMin: Int
  let tempMax: Int
  
  static func from(weatherResponse: WeatherResponse) -> WeatherTemperature {
    WeatherTemperature(temp: Int(weatherResponse.main.temp),
                       tempMin: Int(weatherResponse.main.tempMin),
                       tempMax: Int(weatherResponse.main.tempMax))
  }
}

struct WeatherDetails {
  let feelsLike: Int
  let humidity: Int
  let pressure: Int
  
  static func from(weatherResponse: WeatherResponse) -> WeatherDetails {
    WeatherDetails(feelsLike: Int(weatherResponse.main.feelsLike),
                                 humidity: weatherResponse.main.humidity,
                                 pressure: weatherResponse.main.pressure)
  }
}

enum WindDirection: String {
  case north = "N"
  case south = "S"
  case east = "E"
  case west = "W"
  case northwest = "NW"
  case northeast = "NE"
  case southeast = "SE"
  case southwest = "SW"
  
  static func from(degrees: Int) -> WindDirection {
    // @todo convert degrees to wind direction
    return .north
  }
}

struct WindModel {
  let speed: Int
  let direction: WindDirection
  let gust: Int
  
  static func from(weatherResponse: WeatherResponse) -> WindModel {
    WindModel(speed: Int(weatherResponse.wind.speed),
              direction: WindDirection.from(degrees: weatherResponse.wind.deg),
              gust: Int(weatherResponse.wind.gust ?? 0.0))
  }
}

enum WeatherPrecipitationCondition {
  case rain
  case snow
}

struct WeatherPrecipitation {
  let condition: WeatherPrecipitationCondition
  let inches: Double
  
  static func from(weatherResponse: WeatherResponse) -> WeatherPrecipitation? {
    if let rain = weatherResponse.rain, let oneHour = rain.oneHour {
      return WeatherPrecipitation(condition: .rain, inches: oneHour)
    }
    if let snow = weatherResponse.snow, let oneHour = snow.oneHour {
      return WeatherPrecipitation(condition: .snow, inches: oneHour)
    }
    return nil
  }
}

struct WeatherSunTimes {
  let sunrise: Date
  let sunset: Date
  
  static func from(weatherResponse: WeatherResponse) -> WeatherSunTimes {
    WeatherSunTimes(sunrise: Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunrise)),
                    sunset: Date(timeIntervalSince1970: TimeInterval(weatherResponse.sys.sunset)))
  }
}

struct WeatherModel {
  let cityName: String
  let summary: WeatherSummary?
  let temperature: WeatherTemperature
  let details: WeatherDetails
  let wind: WindModel
  let precipitation: WeatherPrecipitation?
  let sun: WeatherSunTimes
  
  static func from(weatherResponse: WeatherResponse) -> WeatherModel {
    WeatherModel(cityName: weatherResponse.cityName,
                 summary: WeatherSummary.from(weatherResponse: weatherResponse),
                 temperature:WeatherTemperature.from(weatherResponse: weatherResponse),
                 details: WeatherDetails.from(weatherResponse: weatherResponse),
                 wind: WindModel.from(weatherResponse: weatherResponse),
                 precipitation: WeatherPrecipitation.from(weatherResponse: weatherResponse),
                 sun: WeatherSunTimes.from(weatherResponse: weatherResponse))
  }
}
