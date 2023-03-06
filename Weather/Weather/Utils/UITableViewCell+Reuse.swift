//
//  UITableView+Reuse.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/5/23.
//

import Foundation
import UIKit

extension UITableViewCell {
  static var cellReuseIdentifier: String {
    String(describing: self)
  }
}

