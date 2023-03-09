//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import CoreLocation

typealias WeatherViewModelAssetCompletion = (_ imageData: Data) -> Void

private let TAG = "WeatherViewModel"

class WeatherViewModel : NSObject {
  
  @MainActor @Published var weather : WeatherModel?
  @MainActor @Published var fetchError : Error?
  
  private let repo: WeatherRepositoryProtocol
  private let locationManager: CLLocationManager
  
  init(repo: WeatherRepositoryProtocol) {
    locationManager = CLLocationManager()
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.repo = repo
    super.init()
    locationManager.delegate = self
  }
  
  // MARK: - public methods
  
  @MainActor func loadLastSearch() {
    loadLastSearchAsync()
  }
  
  @MainActor func fetchWeather(forCity city: String, state: String, country: String) {
    self.fetchWeatherAsync(forCity: city, state: state, country: country)
  }
  
  @MainActor func fetchGeoLocationWeather() {
    Log.verbose(TAG, #function)
    checkAuthorizationStatusAndRequestLocation()
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
        switch(result) {
        case .failure(let error):
          Log.error(TAG, error)
          self.publish(error: error)
        case .success(let response):
          self.publishUpdated(weatherResponse: response)
        }
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
      let params = WeatherGeocodingSearchParams(city: city, state: state, country: country)
      self.repo.fetchWeather(searchParams: params) { result in
        switch(result) {
        case .failure(let error):
          Log.error(TAG, error)
          self.publish(error: error)
        case .success(let response):
          self.publishUpdated(weatherResponse: response)
        }
      }
    }
  }
  
  private func publishUpdated(weatherResponse: WeatherResponse) {
    let weatherModel  = WeatherModel.from(weatherResponse: weatherResponse)
    DispatchQueue.main.async {
      self.weather = weatherModel
    }
  }
  
  private func publish(error: Error) {
    DispatchQueue.main.async {
      self.fetchError = error
    }
  }
}

extension WeatherViewModel : CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // if we succesfully got the location, then fetch weather based on geo-coordinates.
    if let location = locations.first {
      let latitude = location.coordinate.latitude
      let longitude = location.coordinate.longitude
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        guard let self = self else {
          Log.error(TAG, "self is nil")
          return
        }
        let params = WeatherGeoCoordinatesParams(lat: latitude, lon: longitude)
        self.repo.fetchWeather(searchParams: params) { result in
          switch(result) {
          case .failure(let error):
            Log.error(TAG, error)
          case .success(let response):
            self.publishUpdated(weatherResponse: response)
          }
        }
      }
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkAuthorizationStatusAndRequestLocation()
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    Log.error(TAG, "failed to get location with error - \(error)")
  }
  
  private func checkAuthorizationStatusAndRequestLocation() {
    switch self.locationManager.authorizationStatus {
    case .authorizedWhenInUse:  // Location services are available.
      self.locationManager.requestLocation()
    case .restricted, .denied:  // Location services currently unavailable.
      Log.verbose(TAG, "Location denied")
    case .notDetermined:        // Authorization not determined yet.
      self.locationManager.requestWhenInUseAuthorization()
    default:
      break
    }
  }
}
