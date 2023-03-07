//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import SwiftUI

struct WeatherHeaderView: View {
  
  @State var searchText: String
  
    var body: some View {
      VStack {
        Text(searchText)
      }
    }
}

struct WeatherHeaderView_Previews: PreviewProvider {
    static var previews: some View {
      WeatherHeaderView(searchText: "London, UK")
    }
}
