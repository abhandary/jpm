//
//  WeatherSummaryCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

// create cell that shows a UIImageView and a UILabel. 
// The UIImageView is the weather icon and left aligned with a width of 50 left margin of 10
// UILabel that shows the weather condition and left aligned and right of the UIImageView

class WeatherSummaryCell : UITableViewCell, WeatherCellProtocol {

  let weatherIconImageView = UIImageView()
  let weatherConditionLabel = UILabel()


  func setupCellWith(weatherModel: WeatherModel) {
    if let summary = weatherModel.summary {
      weatherConditionLabel.text = summary.conditionDescription
      if let icon = summary.conditionIcon {
        weatherIconImageView.loadImage(url: icon)
      }
      NSLayoutConstraint.activate(staticConstraints())
    } else {
      NSLayoutConstraint.deactivate(staticConstraints())
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.addSubview(weatherIconImageView)
    self.contentView.addSubview(weatherConditionLabel)
    weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
    weatherConditionLabel.translatesAutoresizingMaskIntoConstraints = false
    weatherConditionLabel.numberOfLines = 0
    weatherConditionLabel.lineBreakMode = .byWordWrapping
    weatherConditionLabel.font = UIFont.systemFont(ofSize: 20)
    weatherConditionLabel.textColor = .black
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // setup header view and table view contraints
    constraints.append(contentsOf:[ 
      weatherIconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
      weatherIconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
      weatherIconImageView.widthAnchor.constraint(equalToConstant: 50),
      weatherIconImageView.heightAnchor.constraint(equalToConstant: 50),
      
      weatherConditionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
      weatherConditionLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 10),
      weatherConditionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      weatherConditionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
    ])
    return constraints
  }
}
