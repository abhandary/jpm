//
//  URLSessionProtocol.swift
//  JPM
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

protocol URLSessionProtocol {
  func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession : URLSessionProtocol {}
