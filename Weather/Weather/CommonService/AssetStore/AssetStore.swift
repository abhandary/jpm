//
//  AssetStore.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

private let TAG = "AssetStore"

enum AssetStoreError : Error {
  case networkError
}

typealias AssetStoreResultCompletion = (Result<Asset, AssetStoreError>) -> Void

class AssetStore : AssetStoreProtocol {
  
  private let session: NetworkSessionProtocol
  
  private var cache = NSCache<NSURL, NSData>()
  
  static let shared = AssetStore()
  
  //MARK: public methods
  
  init(session: NetworkSessionProtocol = URLSession.shared,
       cache: NSCache<NSURL, NSData> = NSCache<NSURL, NSData>()) {
    self.cache = cache
    self.session = session
  }
  
  func fetchAsset(url: URL, completion: @escaping AssetStoreResultCompletion) {
    
    if let stored = self.cache.object(forKey: url as NSURL) {
      completion(.success(Asset(url: url, state: .cache, data: stored as Data)))
      return
    }
    
    let urlRequest = URLRequest(url: url)
    self.session.loadData(from: urlRequest) { [weak self] result in
      switch(result) {
      case .success(let data):
        self?.cache.setObject(data as NSData, forKey: url as NSURL)
        completion(.success(Asset(url: url, state: .downloaded, data: data)))
      case .failure(let error):
        Log.error(TAG, error)
        completion(.failure(.networkError))
      }
    }
  }
}

