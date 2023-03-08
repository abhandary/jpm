//
//  WeatherTemperatureCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

// create a cell with two lines text
// The first line shows an up arrow followed by max temperature, followed by a down arrow followed by min temperature.
// the max temperature label has a left margin of 10, followed by a padding of 50, followed by min temperature label.
// The second line shows the current temperature in large letters. 
// The temperature numbers have a degree symbol after them.

class WeatherTemperatureCell : UITableViewCell, WeatherCellProtocol {
  
  let minTemperatureLabel = UILabel()
  let maxTemperatureLabel = UILabel()
  let currentTemperatureLabel = UILabel()
  
  func setupCellWith(weatherModel: WeatherModel) {
    let temperature = weatherModel.temperature
    minTemperatureLabel.text = "↓ \(temperature.tempMin)°"
    maxTemperatureLabel.text = "↑ \(temperature.tempMax)°"
    currentTemperatureLabel.text = "\(temperature.temp)°"
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(minTemperatureLabel)
    self.contentView.addSubview(maxTemperatureLabel)
    self.contentView.addSubview(currentTemperatureLabel)
    minTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    maxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    currentTemperatureLabel.font = UIFont.systemFont(ofSize: 50)
    currentTemperatureLabel.textColor = .black
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // setup header view and table view contraints
    constraints.append(contentsOf:[ 
      
      maxTemperatureLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
      maxTemperatureLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
      
      minTemperatureLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
      minTemperatureLabel.leadingAnchor.constraint(equalTo: self.maxTemperatureLabel.trailingAnchor, constant: 50),
      minTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      
      currentTemperatureLabel.topAnchor.constraint(equalTo: self.maxTemperatureLabel.bottomAnchor, constant: 10),
      currentTemperatureLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
      currentTemperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      currentTemperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
    ])
    return constraints
  }
}
