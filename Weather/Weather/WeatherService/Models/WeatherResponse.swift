//
//  Weather.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main, icon
        case weatherDescription = "description"
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Rain: Codable {
    let oneHour: Double?
    let threeHour: Double?
}

struct Snow: Codable {
    let oneHour: Double?
    let threeHour: Double?
}

struct Clouds: Codable {
    let all: Double
}

struct System: Codable {
    let sunrise: Int
    let sunset: Int
}

struct WeatherCoordinates : Codable {
  let lon: Double
  let lat: Double
}

struct WeatherResponse: Codable {
    let coordinates: WeatherCoordinates
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds
    let dt: Int
    let sys: System
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, wind, rain, snow, clouds, dt, sys
        case coordinates = "coord"
        case cityName = "name"
    }
}
