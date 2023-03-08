//
//  WeatherStateView.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import SwiftUI

class WeatherSubSearchViewBinding: ObservableObject {
  var limit: Int = 2
  
  @Published var text: String = "" {
    didSet {
      if text.count > limit {
        text = String(text.prefix(limit))
      }
    }
  }
  
  @Published var searchPressed: Bool = false
  @Published var locationPressed: Bool = false
}

struct WeatherSubSearchView: View {
  
  @ObservedObject var state: WeatherSubSearchViewBinding
  
  var body: some View {
    HStack {
      Text("State:")
        .padding(.leading, 10)
        .font(.bold(.subheadline)())
      TextField("Enter State", text: $state.text)
      Spacer()
      Button {
        state.locationPressed = true
      } label: {
        Image(systemName: "location")
      }
      Spacer()
        .frame(width: 15.0)
      Button("Run Search") {
        state.searchPressed = true
      }.padding(.trailing, 10.0)
    }.padding(.top, 10)
  }
}

struct WeatherSubSearchView_Previews: PreviewProvider {
  static var previews: some View {
    
    WeatherSubSearchView(state: WeatherSubSearchViewBinding())
  }
}
