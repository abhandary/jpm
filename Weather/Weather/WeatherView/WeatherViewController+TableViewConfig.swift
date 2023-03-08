//
//  WeatherViewController+TableViewConfig.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

// placed in a seperate file to minimize changes to the main ViewController file.
// Ideally as new cells are added or updated, only this file would need to change.
extension WeatherViewController {
  static let rowToCellMapping: [Int: UITableViewCell.Type] = [
    0 : WeatherSummaryCell.self,
    1 : WeatherTemperatureCell.self,
    2 : WeatherDetailsCell.self,
    3 : WeatherWindCell.self,
    4 : WeatherSunTimesCell.self,
    // @todo: 5 : WeatherPrecipitationCell.self,
  ]
}
