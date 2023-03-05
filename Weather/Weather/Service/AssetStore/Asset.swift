//
//  Asset.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

// This enum contains all the possible states an asset record can be in
enum AssetState {
  case placeholder, downloaded, failed, cache
}

struct Asset {
  let url: URL
  let state: AssetState
  let data: Data
  
  init(url:URL, state: AssetState, data: Data) {
    self.url = url
    self.state = state
    self.data = data
  }
}

