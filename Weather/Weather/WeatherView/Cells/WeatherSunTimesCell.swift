//
//  WeatherSunTimesCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

//
//  WeatherDetailsCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit
import SwiftUI


private let placeHolderSunTimesCell = WeatherSunTimes(sunrise: Date.now, sunset: Date.now)

class WeatherSunTimesSwiftUIViewState : ObservableObject {
  @Published var sunTimes: WeatherSunTimes
  
  init(sunTimes: WeatherSunTimes) {
    self.sunTimes = sunTimes
  }
}

// Displays sunrise and sunset times
struct WeatherSunTimesSwiftUIView: View {
  
  @ObservedObject var model: WeatherSunTimesSwiftUIViewState
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 5.0)
      HStack {
        Text("Sunrise and Sunset Times")
          .padding(.leading, 10)
          .font(.title2)
        Spacer()
      }
      Divider()
      HStack {
        Image(systemName: "sunrise")
        Spacer()
        Text(model.sunTimes.sunrise.formatted())
      }.padding(.horizontal, 10)
      Divider()
        .padding(.horizontal, 10)
        .background(Color.black)
        .frame(height: 1)
      HStack {
        Image(systemName: "sunset")
        Spacer()
        Text(model.sunTimes.sunset.formatted())
      }.padding(.horizontal, 10)
      Spacer()
        .frame(height: 10.0)
    }
  }
}

struct WeatherSunTimesSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherSunTimesSwiftUIView(model: WeatherSunTimesSwiftUIViewState(sunTimes: placeHolderSunTimesCell))

  }
}


class WeatherSunTimesCell : UITableViewCell, WeatherCellProtocol {
  
  let weatherSunTimesSwiftUIView = WeatherSunTimesSwiftUIView(model: WeatherSunTimesSwiftUIViewState(sunTimes: placeHolderSunTimesCell))
  var hostingController : UIHostingController<WeatherSunTimesSwiftUIView>!
  
  func setupCellWith(weatherModel: WeatherModel) {
    weatherSunTimesSwiftUIView.model.sunTimes = weatherModel.sun
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    hostingController = UIHostingController<WeatherSunTimesSwiftUIView>(rootView: weatherSunTimesSwiftUIView)
    self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(hostingController.view)
    NSLayoutConstraint.activate(staticConstraints())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

