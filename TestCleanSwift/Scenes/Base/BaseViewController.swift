//
//  BaseViewController.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 8/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

protocol BaseDisplayLogic: class {
  func displayLoader()
  func hideLoader()
}

class BaseViewController: UIViewController, BaseDisplayLogic {
  
  private lazy var loadingView: UIViewController = {
    let loadingView = self.loading
    return loadingView
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = .black
    
  }

  func displayLoader() {
    add(loadingView)
  }
  
  func hideLoader() {
    loadingView.remove()
  }

}
