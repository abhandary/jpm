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
  
  let tableView: UITableView!
  let headerView: UIHostingController<WeatherHeaderView>!
  let viewModel: WeatherViewModel!
  
  init(viewModel: WeatherViewModel) {
    self.viewModel = viewModel
    self.tableView = UITableView()
    self.headerView = UIHostingController(rootView: WeatherHeaderView())
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupViewModel()
    NSLayoutConstraint.activate(staticConstraints())
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
      headerView.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      headerView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      headerView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      headerView.view.heightAnchor.constraint(equalToConstant: WeatherViewController.WEATHER_HEADER_VIEW_HEIGHT),
      
      tableView.topAnchor.constraint(equalTo: headerView.view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    return constraints
  }
}


