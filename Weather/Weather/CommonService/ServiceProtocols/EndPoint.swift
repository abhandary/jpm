//
//  EndPoint.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

//MARK: - Endpoint

public protocol EndPoint {
  func path() -> String
  func request() ->  URLRequest?
  func request(args: [CVarArg]) -> URLRequest?
}
