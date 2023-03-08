//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import SwiftUI

class WeatherHeaderViewBinding: ObservableObject {
  @Published var text: String = ""
}

struct WeatherHeaderView: View {
  
  @ObservedObject var state: WeatherHeaderViewBinding
  
  var body: some View {
    VStack {
      Divider()
      Text(state.text)
        .font(.bold(.title2)())
      Divider()
    }
    .padding(.bottom, 20.0)
    .padding(.top, 10.0)
  }
}

struct WeatherHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    
    WeatherHeaderView(state: WeatherHeaderViewBinding())
  }
}
