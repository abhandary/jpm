//
//  EncoderProtocol.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import Foundation

protocol EncoderProtocol {
  func encode<T>(_ value: T) -> Data? where T : Encodable
}
