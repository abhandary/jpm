//
//  MockNetworkSession.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockNetworkSession : NetworkSessionProtocol {
  
  let result: Result<Data, NetworkError>
  init(result: Result<Data, NetworkError>) {
    self.result = result
  }
  
  func loadData(from endPoint: EndPoint, completion: NetworkCompletion?) {
    completion?(result)
  }
  
  func loadData(from urlRequest: URLRequest, completion: NetworkCompletion?) {
    completion?(result)
  }
  
  
}
