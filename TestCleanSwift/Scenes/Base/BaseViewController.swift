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

//extension BaseDisplayLogic where Self: UIViewController {
//  func displayLoader() {
//    add(loading)
//  }
//
//  func hideLoader() {
//    childViewControllers.filter{ $0 is LoadingViewController }.forEach{ $0.remove() }
//  }
//}

class BaseViewController: UIViewController, BaseDisplayLogic {
  
  private lazy var loadingView: UIViewController = {
    let loadingView = self.loading
    return loadingView
  }()
  
  func displayLoader() {
    add(loadingView)
  }
  
  func hideLoader() {
    loadingView.remove()
  }
}
