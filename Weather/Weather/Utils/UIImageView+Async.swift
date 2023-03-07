//
//  UIAsyncImageView.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

private let TAG = "UIImageView+Async"

extension UIImageView  {
  
  func loadImage(url: URL,
                 assetStore: AssetStoreProtocol = AssetStore.shared) {
    Log.verbose(TAG, #function)
    assetStore.fetchAsset(url: url) { result in
      switch(result) {
      case .success(let asset):
        DispatchQueue.main.async {
          self.image = UIImage(data: asset.data)
        }
      case .failure(let error):
        Log.error(TAG, error)
      }
    }
  }
}
