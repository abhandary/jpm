//
//  MockDecoder.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockDecoder<T> : DecoderProtocol {
  
  var decodedObject: Any
  
  init(_ decodedObject: Any) {
    self.decodedObject = decodedObject
  }
  
  func decode<T: Decodable>(type: T.Type, from data: Data?) -> T? {
    return decodedObject as? T
  }
}
