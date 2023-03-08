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
  
  let textBinding: TextLimitBinding = TextLimitBinding()
  let searchBar: UISearchBar
  let tableView: UITableView
  let headerView: UIHostingController<WeatherHeaderView>
  let stateView: UIHostingController<WeatherStateView>
  let viewModel: WeatherViewModel
  
  var keyStroke: String = ""
  
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    self.tableView = UITableView()
    self.headerView = UIHostingController(rootView: WeatherHeaderView(searchText:""))
    self.stateView = UIHostingController(rootView: WeatherStateView(state: textBinding))
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
    setupStateView()
    setupHeaderView()
    setupTableView()
    setupViewModel()
    NSLayoutConstraint.activate(staticConstraints())
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
    Log.verbose(TAG, "city: \(self.keyStroke)")
    Log.verbose(TAG, "state: \(self.textBinding.text)")
    self.viewModel.fetchWeather(forCity: self.keyStroke, state: self.textBinding.text, country: "USA")
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.keyStroke = ""
  }
}

// MARK: - state view
extension WeatherViewController {
  func setupStateView() {
    self.stateView.view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.stateView.view)
  }
}

// MARK: - UITableView setup and data source
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
  
  private func setupTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate = self
    for value in WeatherViewController.rowToCellMapping.values {
      self.tableView.register(value, forCellReuseIdentifier: value.cellReuseIdentifier)
    }
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.tableView)
    self.tableView.refreshControl = UIRefreshControl()
    self.tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                             for: .valueChanged)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
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

    guard let cellType = WeatherViewController.rowToCellMapping[indexPath.section] else {
      fatalError("unable to dequeue get a cell type for - \(indexPath)")
    }
    
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellType.cellReuseIdentifier) else {
      fatalError("unable to dequeue a cell of type for index path - \(indexPath)")
    }
    cell.contentView.backgroundColor = UIColor.white
    cell.contentView.layer.borderColor = UIColor.black.cgColor
    cell.contentView.layer.borderWidth = 1
    cell.contentView.layer.cornerRadius = 8
    cell.contentView.clipsToBounds = true
    
    if let cellCard = cell as? WeatherCellProtocol {
      cellCard.setupCellWith(weatherModel: weather)
    }

    return cell
  }
  
  private func updateUI(forCell cell: UITableViewCell) {
    cell.contentView.layer.cornerRadius = 10.0
    cell.contentView.layer.borderColor = UIColor.black.cgColor
    cell.contentView.layer.borderWidth = 1.0
    cell.contentView.clipsToBounds = true
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
}

// MARK: - view model
extension WeatherViewController {
  
  private func setupViewModel() {
    viewModel.$weather
      .receive(on: RunLoop.main)
      .sink { weather in self.weatherUpdated()
      }.store(in: &cancellables)
    viewModel.loadLastSearch()
  }
  
  private func weatherUpdated() {
    self.tableView.reloadData()
  }
}

// MARK: - helper methods
extension WeatherViewController {
  
  private static let WEATHER_HEADER_VIEW_HEIGHT = 100.0
  
  private func staticConstraints() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    
    // setup header view and table view contraints
    constraints.append(contentsOf:[
      searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      stateView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      stateView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      stateView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      headerView.view.topAnchor.constraint(equalTo: stateView.view.bottomAnchor),
      headerView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      headerView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      
      tableView.topAnchor.constraint(equalTo: headerView.view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    return constraints
  }
}


