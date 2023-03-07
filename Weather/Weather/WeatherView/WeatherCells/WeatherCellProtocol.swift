//
//  WeatherCellProtocol.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation

protocol WeatherCellProtocol {
  func setupCellWith(weatherModel: WeatherModel)
  static var cellReuseIdentifier: String { get }
}
