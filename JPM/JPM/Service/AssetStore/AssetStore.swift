//
//  AssetStore.swift
//  JPM
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
  
  private let queue = DispatchQueue(label: TAG)
  
  private var cache = NSCache<NSURL, NSData>()
  
  static let shared = AssetStore()
  
  
  //MARK: public methods
  
  init(session: NetworkSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func fetchAsset(url: URL, completion: @escaping AssetStoreResultCompletion) {
    
    queue.async { [weak self] in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      if let stored = self.cache.object(forKey: url as NSURL) {
        completion(.success(Asset(url: url, state: .cache, data: stored as Data)))
        return
      }

      let urlRequest = URLRequest(url: url)
      self.session.loadData(from: urlRequest) { [weak self] result in
        self?.queue.async { [weak self] in
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

  }
}

