//
//  MockFileManager.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import Foundation
@testable import Weather

struct MockFileManager : FileManagerProtocol {
  
  var urls: [URL] = []
  var directoryURLs: [URL] = []
  var contentsAtPath: Data? = nil
  var fileExists: Bool = false
  var removeItemError: Error? = nil
  
  func fileExists(atPath path: String) -> Bool {
    return fileExists
  }
  
  func contents(atPath path: String) -> Data? {
      return contentsAtPath
  }
  func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
    return urls
  }
  func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
    return directoryURLs
  }
  
  func removeItem(at URL: URL) throws {
    if let error = removeItemError {
      throw error
    }
  }
}
