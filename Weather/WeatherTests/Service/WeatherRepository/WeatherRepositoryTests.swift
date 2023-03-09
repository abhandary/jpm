//
//  WeatherRepositoryTests.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import XCTest
@testable import Weather

final class WeatherRepositoryTests: XCTestCase {
  
  func testGeocodingFetch() throws {
    let mockNetworkLoaderResult: Result<WeatherResponse, WeatherNetworkError>
      = .success(MockWeatherResponse.mockNewYorkWeatherResponse!)
    let mockNetworkLoader = MockWeatherNetworkLoader(result: mockNetworkLoaderResult)
    var mockStorageLoader = MockWeatherStorageLoader()
    mockStorageLoader.lastSearchWeatherResponse = .failure(.fileMissingError)
    mockStorageLoader.storedLastSearchWeatherSearchParamsResponse = .failure(.fileMissingError)
    let weatherRepo = WeatherRepository(networkLoader: mockNetworkLoader, storageLoader: mockStorageLoader)
    let searchParams = WeatherGeocodingSearchParams(city: "no such city",
                                                    state: "no such state", country: "no such country")
    weatherRepo.fetchWeather(searchParams: searchParams) { result in
      switch(result) {
      case .success(let response):
        XCTAssertEqual(response.cityName, MockWeatherResponse.mockNewYorkWeatherResponse?.cityName)
      case .failure(let error):
        XCTAssert(false, "unexpectedly got an error - \(error)")
      }
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
