//
//  Log.swift
//  JPM
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

enum Log {
  static func error(_ tag: String, _ message: Any...) {
    print("\(tag): Error:", message)
  }
  static func verbose(_ tag: String, _ message: Any...) {
    print("\(tag): Verbose:", message)
  }
}
