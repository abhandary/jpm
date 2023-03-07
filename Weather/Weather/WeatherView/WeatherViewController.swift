//
//  WeatherViewController.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import UIKit
import Combine
import SwiftUI

class WeatherViewController: UIViewController {
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
    print(self.keyStroke)
    print(self.textBinding.text)
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
extension WeatherViewController: UITableViewDataSource {
  
  private func setupTableView() {
    self.tableView.dataSource = self
    self.tableView.register(WeatherSummaryCell.self,
                            forCellReuseIdentifier: WeatherSummaryCell.cellReuseIdentifier)
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.tableView)
    self.tableView.refreshControl = UIRefreshControl()
    self.tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                             for: .valueChanged)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.weather == nil {
      return 0
    }
    
    return WeatherViewController.NUMBER_OF_WEATHER_DATA_CELLS
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let weather = viewModel.weather else {
      fatalError("expecting a valid weather model")
    }
    guard let cellType = WeatherViewController.rowToCellMapping[indexPath.row] else {
      fatalError("unable to get a valid cell type for - \(indexPath)")
    }
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellType.cellReuseIdentifier) else {
      fatalError("unable to dequeue a cell of type \(cellType) for index path - \(indexPath)")
    }
    if let weatherCell = cell as? WeatherCellProtocol {
      weatherCell.setupCellWith(weatherModel: weather)
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


