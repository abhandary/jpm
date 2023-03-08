//
//  WeatherDiskLoader.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/6/23.
//

import Foundation
import CryptoKit

private let TAG = "WeatherStorageLoader"

struct WeatherStorageLoader : WeatherStorageLoaderProtocol {
  
  private static let lastSearchResponseFile = "lastSearchResponseFile"
  private static let lastSearchParams = "lastSearchParamsFile"
  
  private let fileManager: FileManagerProtocol
  private let encoder: EncoderProtocol
  private let decoder: DecoderProtocol
  
  init(fileManager: FileManagerProtocol = FileManager.default,
       encoder: EncoderProtocol = CustomJSONEncoder(),
       decoder: DecoderProtocol = CustomJSONDecoder()) {
    self.fileManager = fileManager
    self.encoder = encoder
    self.decoder = decoder
  }
  
  // MARK: - public methods
  
  func isLastSearchWeatherResponseStored() -> Bool {
    guard let fileURL = getWeatherFileURL(fileName:WeatherStorageLoader.lastSearchResponseFile) else {
      Log.error(TAG, "unable to get last search weather response file URL")
      return false
    }
    return self.fileManager.fileExists(atPath: fileURL.path)
  }
  
 
  func getStoredLastSearchWeatherSearchParams() -> Result<WeatherSearchParams, WeatherStorageError> {
    guard let fileURL = getWeatherFileURL(fileName: WeatherStorageLoader.lastSearchParams) else {
      Log.error(TAG, "unable to get last search weather response file URL")
      return .failure(.fileURLError)
    }
    
    if self.fileManager.fileExists(atPath: fileURL.path) == false {
      Log.verbose(TAG, "No file stored for file URL - \(fileURL)")
      return .failure(.fileMissingError)
    }
    if let savedData = self.fileManager.contents(atPath: fileURL.path) {
      guard let searchParams = self.decoder.decode(type: WeatherSearchParams.self, from: savedData) else {
        return .failure(.fileDecodingError)
      }
      return .success(searchParams)
    } else {
      Log.error(TAG, "error reading contents of file at path \(fileURL.path)")
      return .failure(.fileReadError)
    }
  }
  
  func getStoredLastSearchWeatherResponse() -> Result<WeatherResponse, WeatherStorageError> {
    
    guard let fileURL = getWeatherFileURL(fileName: WeatherStorageLoader.lastSearchResponseFile) else {
      Log.error(TAG, "unable to get last search weather response file URL")
      return .failure(.fileURLError)
    }
    
    if self.fileManager.fileExists(atPath: fileURL.path) == false {
      Log.verbose(TAG, "No file stored for file URL - \(fileURL)")
      return .failure(.fileMissingError)
    }
    if let savedData = self.fileManager.contents(atPath: fileURL.path) {
      guard let weatherResponse = self.decoder.decode(type: WeatherResponse.self, from: savedData) else {
        return .failure(.fileDecodingError)
      }
      return .success(weatherResponse)
    } else {
      Log.error(TAG, "error reading contents of file at path \(fileURL.path)")
      return .failure(.fileReadError)
    }
  }
  
  func storeLastSearch(params: WeatherSearchParams) {
    guard let fileURL = getWeatherFileURL(fileName: WeatherStorageLoader.lastSearchParams) else {
      Log.error(TAG, "unable to get last search weather response file URL")
      return
    }
    
    guard let encodedData = self.encoder.encode(params) else {
      Log.error(TAG, "unable to encode weather response")
      return
    }
    
    do {
      try encodedData.write(to: fileURL)
      Log.verbose(TAG, "Succesfully wrote to \(fileURL)")
    } catch {
      Log.error(TAG, error)
    }
  }
  
  func storeLastSearch(weatherResponse: WeatherResponse)  {
    
    guard let fileURL = getWeatherFileURL(fileName: WeatherStorageLoader.lastSearchResponseFile) else {
      Log.error(TAG, "unable to get last search weather response file URL")
      return
    }
    
    guard let encodedData = self.encoder.encode(weatherResponse) else {
      Log.error(TAG, "unable to encode weather response")
      return
    }
    
    do {
      try encodedData.write(to: fileURL)
      Log.verbose(TAG, "Succesfully wrote to \(fileURL)")
    } catch {
      Log.error(TAG, error)
    }
  }
  
  // MARK: - private methods
  
  private func getWeatherFileURL(fileName: String) -> URL? {
    let fileURLs = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard fileURLs.count > 0 else {
      Log.error(TAG, "unable to get docments directory")
      return nil
    }
    guard let directoryURL = fileURLs.first else {
      Log.error(TAG, "nil directory URL")
      return nil
    }
    let hashString = SHA256.hash(data:Data(fileName.utf8)).compactMap { String(format: "%02x", $0) }.joined()
    return URL(string: "\(directoryURL.absoluteString)\(hashString)")
  }
  
}
