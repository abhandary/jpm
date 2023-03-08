//
//  WeatherDetailsCell.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit
import SwiftUI

// create a cell that shows a SwiftUI view.
// The SwiftUI view should show the weather details
// The SwiftUI view should be embedded in a UIView and added to the cell's contentView
// The first line of the SwiftUI view should be the text Details which is left aligned with a left margin of 10
// The second line of the SwiftUI view should be a horizontal divider which is 1 point thick and solid
// The third line of the SwiftUI view should be the text Feels Like which is left aligned with a margin of 10, followed by the feels like temperature which is right aligned
// The fourth line of the SwiftUI view should be a horizontal divider which is 1 point thick and dotted
// The fifth line of the SwiftUI view should be the text Humidity which is left aligned with a margin of 10, followed by the humidity percentage which is right aligned
// The sixth line of the SwiftUI view should be a horizontal divider which is 1 point thick and dotted
// The seventh line of the SwiftUI view should be the text Pressure which is left aligned with a margin of 10, followed by the pressure value which is right aligned
// The eighth line of the SwiftUI view should be a horizontal divider which is 1 point thick and dotted

private let placeHolderWeatherDetails = WeatherDetails(feelsLike: 10, humidity: 12, pressure: 20)

class WeatherDetailsSwiftUIViewState : ObservableObject {
  @Published var details: WeatherDetails
  
  init(details: WeatherDetails) {
    self.details = details
  }
}


struct WeatherDetailsSwiftUIView: View {
  
  @ObservedObject var model: WeatherDetailsSwiftUIViewState
  
  var body: some View {
    VStack {
      HStack {
        Text("Details")
          .padding(.leading, 10)
          .font(.title2)
        Spacer()
      }
      Divider()
        .padding(.horizontal, 10)
        .background(Color.black)
        .frame(height: 1)
      HStack {
        Text("Feels Like")
          .padding(.leading, 10)
          .font(.subheadline)
        Spacer()
        Text("\(model.details.feelsLike)")
          .padding(.trailing, 10)
          .font(.subheadline)
      }
      Divider()
      HStack {
        Text("Humidity")
          .padding(.leading, 10)
          .font(.subheadline)
        Spacer()
        Text("\(model.details.humidity)")
          .padding(.trailing, 10)
          .font(.subheadline)
      }
      Divider()
      HStack {
        Text("Pressure")
          .padding(.leading, 10)
          .font(.subheadline)
        Spacer()
        Text("\(model.details.pressure)")
          .padding(.trailing, 10)
          .font(.subheadline)
      }
      Divider()
    }
  }
}

struct WeatherDetailsSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherDetailsSwiftUIView(model: WeatherDetailsSwiftUIViewState(details: placeHolderWeatherDetails))

  }
}


class WeatherDetailsCell : UITableViewCell, WeatherCellProtocol {
  
  let weatherDetailsSwiftUIView = WeatherDetailsSwiftUIView(model: WeatherDetailsSwiftUIViewState(details: placeHolderWeatherDetails))
  var hostingController : UIHostingController<WeatherDetailsSwiftUIView>!
  
  func setupCellWith(weatherModel: WeatherModel) {
    weatherDetailsSwiftUIView.model.details = weatherModel.details
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    hostingController = UIHostingController<WeatherDetailsSwiftUIView>(rootView: weatherDetailsSwiftUIView)
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
