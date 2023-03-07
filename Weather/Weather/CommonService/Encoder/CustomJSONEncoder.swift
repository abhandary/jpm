//
//  CustomJSONEncoder.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import Foundation

private let TAG = "CustomJSONEncoder"

struct CustomJSONEncoder: EncoderProtocol {
  func encode<T>(_ value: T) -> Data? where T : Encodable {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    var encodedData: Data?
    do {
      encodedData = try encoder.encode(value)
    } catch let EncodingError.invalidValue(value, context) {
      Log.error(TAG, "invalid value: \(value)", context.debugDescription)
      Log.error(TAG, "codingPath:", context.codingPath)
    } catch (let error) {
      Log.error(TAG, error)
    }
    
    return encodedData
  }
}
