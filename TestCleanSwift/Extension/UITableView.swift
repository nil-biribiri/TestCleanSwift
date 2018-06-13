//
//  UITableView.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 14/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  func scrollToBottom(animated: Bool = true) {
    let sections = self.numberOfSections
    let rows = self.numberOfRows(inSection: sections - 1)
    if (rows > 0){
      self.scrollToRow(at: IndexPath(row: rows - 1, section: sections - 1), at: .bottom, animated: true)
    }
  }
}
