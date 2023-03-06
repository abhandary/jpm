//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation

typealias WeatherViewModelAssetCompletion = (_ imageData: Data) -> Void

private let TAG = "WeatherViewModel"

class WeatherViewModel {

  @MainActor @Published var weather : WeatherModel?
  
  private let repo: WeatherRepositoryProtocol
  private let assetStore: AssetStoreProtocol

  init(repo: WeatherRepositoryProtocol,
       assetStore: AssetStoreProtocol) {
    self.repo = repo
    self.assetStore = assetStore
  }
  
  // MARK: - public methods
  
  @MainActor func loadLastSearch() {
    loadLastSearchAsync()
  }
  
  @MainActor func fetchWeather(forCity city: String, state: String, country: String) {
    self.fetchWeatherAsync(forCity: city, state: state, country: country)
  }
  
  
  @MainActor func fetchAsset(urlString: String,
                             completion: @escaping WeatherViewModelAssetCompletion) {
    
    guard let url = URL(string: urlString) else {
      Log.error(TAG, "unable to form URL with string - \(urlString)")
      return
    }
    
    fetchAssetAsync(url: url, completion: completion)
  }
  
  // MARK: - private methods
  
  private func loadLastSearchAsync() {
    Log.verbose(TAG, #function)
    // letting go of the main thread for I/O bound operations
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      self.repo.loadLastSearch { result in
        
      }
    }
  }
  
  private func fetchWeatherAsync(forCity city: String, state: String, country: String) {
    Log.verbose(TAG, #function)
    // letting go of the main thread for I/O bound operations
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      self.repo.fetchWeather(forCity: city,
                        state: state,
                        country: country) { result in
        switch(result) {
        case .failure(let error):
          Log.error(TAG, error)
        case .success(let response):
          // get weather model from weather response and update the published property
          let weatherModel  = WeatherModel.from(weatherResponse: response)
          DispatchQueue.main.async {
            self.weather = weatherModel
          }
        }
      }
    }
  }
  
  private func fetchAssetAsync(url: URL,
                               completion: @escaping WeatherViewModelAssetCompletion) {
    Log.verbose(TAG, #function)
    // letting go of the main thread for I/O bound operations
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self = self else {
        Log.error(TAG, "self is nil")
        return
      }
      self.assetStore.fetchAsset(url: url) { result in
        switch(result) {
        case .success(let asset):
          DispatchQueue.main.async {
            completion(asset.data)
          }
        case .failure(let error):
          Log.error(TAG, error)
        }
      }
    }
  }
}
