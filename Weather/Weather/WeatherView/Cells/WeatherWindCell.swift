//
//  WeatherWindCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit
import SwiftUI

// create a cell that shows a SwiftUI view.
// The SwiftUI view should show the weather wind details
// The SwiftUI view should be embedded in a UIView and added to the cell's contentView
// The first line of the SwiftUI view should be the text Wind which is left aligned with a left margin of 10
// The second line of the SwiftUI view should be a horizontal divider which is 1 point thick and solid
// Below the divider, the SwiftUI view should show a left aligned image with a left margin of 30 and a width of 100
// To the right of the image the SwiftUI view should show the wind speed and direction text which is right aligned with a right margin of 10


private let placeHolderWeatherWind = WindModel(speed: 10, direction: .north, gust: 10)

struct WeatherWindSwiftUIView: View {
  
  @State var wind: WindModel = placeHolderWeatherWind

    var body: some View {
      VStack {
        HStack {
          Text("Wind")
            .padding(.leading, 10)
          Spacer()
        }
        Divider()
          .padding(.horizontal, 10)
          .background(Color.black)
          .frame(height: 1)
        HStack {
          Image(systemName: "windmill")
            .padding(.leading, 10)
            .frame(width: 100)
          VStack {
            Text("\(wind.speed) \(wind.direction.rawValue)")
              .padding(.leading, 10)
              .font(.subheadline)
            Divider()
            HStack {
              Spacer()
              Image(systemName: "gust")
              Text("\(wind.gust)")
                .padding(.trailing, 10)
                .font(.subheadline)
            }
            
          }

        }
      }
    }

}

struct WeatherWindSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
      WeatherWindSwiftUIView()
    }
}


class WeatherWindCell : UITableViewCell, WeatherCellProtocol {

  let weatherWindSwiftUIView = WeatherWindSwiftUIView()
  var hostingController: UIHostingController<WeatherWindSwiftUIView>!

  func setupCellWith(weatherModel: WeatherModel) {
    weatherWindSwiftUIView.wind = weatherModel.wind
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    super.init(style: style, reuseIdentifier: reuseIdentifier)
    hostingController = UIHostingController<WeatherWindSwiftUIView>(rootView: weatherWindSwiftUIView)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(hostingController.view)
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
      hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
    ])
    return constraints
  }
}
