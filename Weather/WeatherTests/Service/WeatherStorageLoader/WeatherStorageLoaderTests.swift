//
//  WeatherStorageLoaderTests.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import XCTest
@testable import Weather

final class WeatherStorageLoaderTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testIsLastSearchWeatherResponseStoredSuccess() {
    var mockFileManager = MockFileManager()
    let url = URL(string: "file://storednowhere")!
    mockFileManager.fileExists = true
    mockFileManager.urls = [url]
    let storageLoader = WeatherStorageLoader(fileManager: mockFileManager)
      
    XCTAssertTrue(storageLoader.isLastSearchWeatherResponseStored())
  }
  
  func testIsLastSearchWeatherResponseStoredFailure() {
    var mockFileManager = MockFileManager()
    let url = URL(string: "file://storednowhere")!
    mockFileManager.fileExists = false
    mockFileManager.urls = [url]
    let storageLoader = WeatherStorageLoader(fileManager: mockFileManager)
      
    XCTAssertFalse(storageLoader.isLastSearchWeatherResponseStored())
  }
  
  func testLastSearchRetrievalFailure() {
    var mockFileManager = MockFileManager()
    let url = URL(string: "file://storednowhere")!
    mockFileManager.fileExists = false
    mockFileManager.urls = [url]
    let storageLoader = WeatherStorageLoader(fileManager: mockFileManager)
    
    let result = storageLoader.getStoredLastSearchWeatherResponse()
    switch(result) {
    case .success(let response):
      XCTAssert(false, "unexpectedly got a response - \(response)")
    case .failure(let error):
        print(error)
    }
  }
  
  func testLastSearchParamsRetrievalFailure() {
    var mockFileManager = MockFileManager()
    let url = URL(string: "file://storednowhere")!
    mockFileManager.fileExists = false
    mockFileManager.urls = [url]
    let storageLoader = WeatherStorageLoader(fileManager: mockFileManager)
    
    let result = storageLoader.getStoredLastSearchWeatherSearchParams()
    switch(result) {
    case .success(let response):
      XCTAssert(false, "unexpectedly got a response - \(response)")
    case .failure(let error):
        print(error)
    }
  }
  
  func testLastSearchRetrievalSuccess() {
    
    var mockFileManager = MockFileManager()
    let url = URL(string: "file://storednowhere")!
    mockFileManager.fileExists = true
    mockFileManager.urls = [url]
    mockFileManager.contentsAtPath = MockWeatherResponse.mockNewYorkJsonData
    let storageLoader = WeatherStorageLoader(fileManager: mockFileManager)
    
    let result = storageLoader.getStoredLastSearchWeatherResponse()
    switch(result) {
    case .success(let response):
      // compare a few fields
      XCTAssertEqual(MockWeatherResponse.mockNewYorkWeatherResponse?.cityName, response.cityName)
      XCTAssertEqual(MockWeatherResponse.mockNewYorkWeatherResponse?.dt, response.dt)
      XCTAssertEqual(MockWeatherResponse.mockNewYorkWeatherResponse?.main.temp, response.main.temp)
    case .failure(let error):
      XCTAssert(false, "unexpectedly got an error - \(error)")
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
