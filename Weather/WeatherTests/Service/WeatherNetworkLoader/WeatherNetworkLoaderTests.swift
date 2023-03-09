//
//  WeatherNetworkLoaderTests.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import XCTest
@testable import Weather

final class WeatherNetworkLoaderTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGeocodingQuery() throws {
    let mockResult: Result<Data, NetworkError> = .success(Data())
    let mockDecoder = MockDecoder<WeatherResponse>(MockWeatherResponse.mockNewYorkWeatherResponse!)
    let mockNetworkSession = MockNetworkSession(result: mockResult)
    
    let weatherNetworkLoader = WeatherNetworkLoader(session: mockNetworkSession, decoder: mockDecoder)
    weatherNetworkLoader.query(forCity: "some city",
                               state: "some state",
                               country: "some country") { result in
      switch(result) {
      case .success(let response):
        XCTAssertEqual(response.cityName, MockWeatherResponse.mockNewYorkWeatherResponse?.cityName)
      case .failure(let error):
        XCTAssert(false, "unexpectedly got error - \(error)")
      }
    }
  }
  
  func testGeocoordinatesQuery() throws {
    
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
