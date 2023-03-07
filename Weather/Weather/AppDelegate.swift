//
//  AppDelegate.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let weatherNetwork = WeatherNetworkLoader()
    let weatherStorage = WeatherStorageLoader()
    let weatherRepo = WeatherRepository(networkLoader: weatherNetwork, storageLoader: weatherStorage)
    let viewModel = WeatherViewModel(repo: weatherRepo)
    let weatherVC = WeatherViewController(viewModel: viewModel)
    window?.rootViewController = weatherVC
    window?.makeKeyAndVisible()
    return true
  }
}

