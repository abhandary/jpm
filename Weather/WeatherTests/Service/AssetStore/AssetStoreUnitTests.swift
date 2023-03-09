//
//  AssetStoreUnitTests.swift
//  WeatherTests
//
//  Created by Akshay Bhandary on 3/8/23.
//

import XCTest
@testable import Weather

final class AssetStoreUnitTests: XCTestCase {
  
  func testFetchingWithNothingInCacheAndNetworkFails() {
    // setup asset store
    let mockNetworkSession = MockNetworkSession(result: .failure(.noData))
    let assetStore = AssetStore(session: mockNetworkSession)
    
    guard let url = URL(string: "http://goingnowhere.com") else {
      XCTAssert(false, "unable to form url from test url string")
      return
    }
    
    // run the fetch method
    assetStore.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        XCTAssert(false, "unexpectedly got an asset - \(asset)")
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func testFetchingWithAssetInCache() {
    // setup asset store
    guard let url = URL(string: "http://goingnowhere.com") else {
      XCTAssert(false, "unable to form url from test url string")
      return
    }
    
    let mockNetworkSession = MockNetworkSession(result: .failure(.noData))
    let cache = NSCache<NSURL, NSData>()
    let mockStoredAsset = Data()
    cache.setObject(mockStoredAsset as NSData, forKey: url as NSURL)
    let assetStore = AssetStore(session: mockNetworkSession, cache:cache)
    
    // run the fetch method
    assetStore.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        XCTAssertEqual(asset.data, mockStoredAsset)
        XCTAssertEqual(asset.url, url)
        XCTAssertEqual(asset.state, .cache)
      case .failure(let error):
        XCTAssert(false, "unexpectedly got an error - \(error)")
      }
    }
  }
  
  func testFetchingWithNoAssetInCacheAssetFetchedFromNetwork() {
    // setup asset store
    guard let url = URL(string: "http://goingnowhere.com") else {
      XCTAssert(false, "unable to form url from test url string")
      return
    }

    let mockNetworkAsset = Data()
    let mockNetworkSession = MockNetworkSession(result: .success(mockNetworkAsset))
    
    let assetStore = AssetStore(session: mockNetworkSession)
    
    // run the fetch method
    assetStore.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        XCTAssertEqual(asset.data, mockNetworkAsset)
        XCTAssertEqual(asset.url, url)
        XCTAssertEqual(asset.state, .downloaded)
      case .failure(let error):
        XCTAssert(false, "unexpectedly got an error - \(error)")
      }
    }
  }
  
  func testFetchingWithAssetInCacheAssetAvailableOnNetwork() {
    // setup asset store
    guard let url = URL(string: "http://goingnowhere.com") else {
      XCTAssert(false, "unable to form url from test url string")
      return
    }

    let mockNetworkAsset = Data()
    let mockNetworkSession = MockNetworkSession(result: .success(mockNetworkAsset))
    let cache = NSCache<NSURL, NSData>()
    let mockStoredAsset = Data()
    cache.setObject(mockStoredAsset as NSData, forKey: url as NSURL)
    let assetStore = AssetStore(session: mockNetworkSession, cache: cache)
    
    // run the fetch method
    assetStore.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        XCTAssertEqual(asset.data, mockStoredAsset)
        XCTAssertEqual(asset.url, url)
        XCTAssertEqual(asset.state, .cache)
      case .failure(let error):
        XCTAssert(false, "unexpectedly got an error - \(error)")
      }
    }
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // measure performance of most intensive path
      guard let url = URL(string: "http://goingnowhere.com") else {
        XCTAssert(false, "unable to form url from test url string")
        return
      }

      let mockNetworkAsset = Data()
      let mockNetworkSession = MockNetworkSession(result: .success(mockNetworkAsset))
      
      let assetStore = AssetStore(session: mockNetworkSession)
      
      // run the fetch method
      assetStore.fetchAsset(url: url) { result in
        switch(result) {
        case .success(let asset):
          XCTAssertEqual(asset.data, mockNetworkAsset)
          XCTAssertEqual(asset.url, url)
          XCTAssertEqual(asset.state, .downloaded)
        case .failure(let error):
          XCTAssert(false, "unexpectedly got an error - \(error)")
        }
      }
    }
  }
  
}
