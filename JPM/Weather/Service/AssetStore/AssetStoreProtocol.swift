//
//  AssetStoreProtocol.swift
//  JPM
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

protocol AssetStoreProtocol {
  func fetchAsset(url: URL, completion: @escaping AssetStoreResultCompletion)
}
