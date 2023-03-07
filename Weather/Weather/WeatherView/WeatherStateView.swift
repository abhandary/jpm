//
//  WeatherStateView.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import SwiftUI

class TextLimitBinding: ObservableObject {
    var limit: Int = 2

    @Published var text: String = "" {
        didSet {
            if text.count > limit {
                text = String(text.prefix(limit))
            }
        }
    }
}

struct WeatherStateView: View {
  
  @ObservedObject var state: TextLimitBinding
  
    var body: some View {
      HStack {
        Text("State:")
          .padding(.leading, 10)
          .font(.bold(.subheadline)())
        TextField("Enter State", text: $state.text)
      }
    }
}

struct WeatherStateView_Previews: PreviewProvider {
    static var previews: some View {
      
      WeatherStateView(state: TextLimitBinding())
    }
}
