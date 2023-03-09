//
//  WeatherViewController.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import UIKit
import Combine
import SwiftUI

private let TAG = "WeatherViewController"

class WeatherViewController: UIViewController {
  
  private let cellSpacingHeight = 10.0
  
  var cancellables: Set<AnyCancellable> = []
  
  let subSearchViewBinding: WeatherSubSearchViewBinding = WeatherSubSearchViewBinding()
  let headerViewBinding: WeatherHeaderViewBinding = WeatherHeaderViewBinding()
  let searchBar: UISearchBar
  let tableView: UITableView
  let headerView: UIHostingController<WeatherHeaderView>
  let subSearchView: UIHostingController<WeatherSubSearchView>
  let viewModel: WeatherViewModel
  
  var keyStroke: String = ""
  
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    self.tableView = UITableView()
    self.headerView = UIHostingController(rootView: WeatherHeaderView(state: headerViewBinding))
    self.subSearchView = UIHostingController(rootView: WeatherSubSearchView(state: subSearchViewBinding))
    self.searchBar = UISearchBar()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupSearchBar()
    setupSubSearchView()
    setupLocationButton()
    setupSearchButton()
    setupHeaderView()
    setupTableView()
    setupViewModel()
    NSLayoutConstraint.activate(staticConstraints())
  }
}

// MARK: - Search button
extension WeatherViewController  {
  func setupSearchButton() {
    self.subSearchViewBinding.$searchPressed
      .receive(on: RunLoop.main)
      .sink { [weak self] weather in
        if self?.subSearchViewBinding.searchPressed == true {
          self?.searchButtonPressed()
        }
      }.store(in: &cancellables)
  }
  
  func searchButtonPressed() {
    Log.verbose(TAG, "city: \(self.keyStroke)")
    Log.verbose(TAG, "state: \(self.subSearchViewBinding.text)")
    let city = self.keyStroke != "" ? self.keyStroke : "New York"
    self.viewModel.fetchWeather(forCity: city, state: self.subSearchViewBinding.text, country: "USA")
  }
}

// MARK: - Location button {
extension WeatherViewController  {
  func setupLocationButton() {
    self.subSearchViewBinding.$locationPressed
      .receive(on: RunLoop.main)
      .sink { [weak self] weather in
        if self?.subSearchViewBinding.locationPressed == true {
          self?.locationButtonPressed()
        }
      }.store(in: &cancellables)
  }
  
  func locationButtonPressed() {
    Log.verbose(TAG, "location button pressed")
    self.viewModel.fetchGeoLocationWeather()
  }
}

// MARK: - UISearchBar setup and delegate
extension WeatherViewController: UISearchBarDelegate {
  private func setupSearchBar() {
    self.searchBar.delegate = self
    self.searchBar.translatesAutoresizingMaskIntoConstraints = false
    self.searchBar.prompt = "Enter US city name to search, followed by state"
    self.view.addSubview(searchBar)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.keyStroke = searchText
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchButtonPressed()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.keyStroke = ""
  }
}

// MARK: - state view
extension WeatherViewController {
  func setupSubSearchView() {
    self.subSearchView.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.subSearchView.view)
  }
}

// MARK: - UITableView setup and data source
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
  
  private func setupTableView() {
    
    // setup delegate, datasource, rowheight and setup for constraints
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.tableView)
    
    // register all the wind cell used for the wind cards
    for value in WeatherViewController.rowToCellMapping.values {
      self.tableView.register(value, forCellReuseIdentifier: value.cellReuseIdentifier)
    }
    
    
    // refresh control
    self.tableView.refreshControl = UIRefreshControl()
    self.tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                             for: .valueChanged)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // setup each card as a new section so we can add spacing between the cards
    if viewModel.weather == nil {
      return 0
    }
    return WeatherViewController.rowToCellMapping.keys.count
  }
  
  // Set the spacing between sections
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return self.cellSpacingHeight
  }
  
  // Make the background color show through
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.weather == nil {
      return 0
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let weather = viewModel.weather else {
      fatalError("expecting a valid weather model")
    }
    
    // find the cell that matches the Wind card type that will be displayed
    guard let cellType = WeatherViewController.rowToCellMapping[indexPath.section] else {
      fatalError("unable to dequeue get a cell type for - \(indexPath)")
    }
    
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellType.cellReuseIdentifier) else {
      fatalError("unable to dequeue a cell of type for index path - \(indexPath)")
    }
    
    // round corners and set a border on the cell
    cell.contentView.backgroundColor = UIColor.white
    cell.contentView.layer.borderColor = UIColor.black.cgColor
    cell.contentView.layer.borderWidth = 1
    cell.contentView.layer.cornerRadius = 8
    cell.contentView.clipsToBounds = true
    
    // setup the wind card cell with the weather model
    if let cellCard = cell as? WeatherCellProtocol {
      cellCard.setupCellWith(weatherModel: weather)
    }
    
    return cell
  }
  
  @objc func handleRefreshControl() {
    viewModel.loadLastSearch()
  }
}

// MARK: - header view
extension WeatherViewController {
  func setupHeaderView() {
    self.headerView.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.headerView.view)
  }
  
  func updateHeaderView() {
    // header view shows city name and date time that's in the response
    if let cityName = self.viewModel.weather?.cityName,
       let dateTime = self.viewModel.weather?.dateTime {
      self.headerViewBinding.text = "\(cityName) \(dateTime.formatted())"
    }
  }
}

// MARK: - view model
extension WeatherViewController {
  
  private func setupViewModel() {
    
    // whenever the viewmodel has a new weather model
    // we recieve it here and update the screen
    viewModel.$weather
      .receive(on: RunLoop.main)
      .sink { weather in self.weatherUpdated()
      }.store(in: &cancellables)
    viewModel.loadLastSearch()
    
    // listen for errors
    viewModel.$fetchError
      .receive(on: RunLoop.main)
      .sink { error in self.fetchError(error: error)
      }.store(in: &cancellables)
    viewModel.loadLastSearch()
  }
  
  private func weatherUpdated() {
    updateHeaderView()
    self.tableView.refreshControl?.endRefreshing()
    self.tableView.reloadData()
  }
  
  private func fetchError(error: Error?) {
    if let error = error {
      Log.error(TAG, "error recieved at view - \(error)")
      self.showToast(message: "Something went wrong", font: .systemFont(ofSize: 10))
    }
  }
}

// MARK:- show toast
extension WeatherViewController {
  
  private func showToast(message : String, font: UIFont) {
    
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }

}

// MARK: - helper methods
extension WeatherViewController {
  
  private static let WEATHER_HEADER_VIEW_HEIGHT = 100.0
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // header view, search bar, the view below the search bar, and table view contraints
    constraints.append(contentsOf:[
      searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      subSearchView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      subSearchView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      subSearchView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      headerView.view.topAnchor.constraint(equalTo: subSearchView.view.bottomAnchor, constant: 20.0),
      headerView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      headerView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      tableView.topAnchor.constraint(equalTo: headerView.view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    return constraints
  }
}


