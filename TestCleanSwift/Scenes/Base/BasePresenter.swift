//
//  BaseInteractor.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 8/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

protocol BasePresenterLogic {
  func showLoading()
  func hideLoading()
}

//extension BasePresenterLogic where Self: BaseDisplayLogic {
//  func showLoading() {
////    self.displayLoader()
//  }
//
//  func hideLoading() {
////    self.hideLoader()
//  }
//
//}

class BasePresenter {
  
  weak var baseViewController: BaseDisplayLogic?

  func showLoading() {
    baseViewController?.displayLoader()
  }
  
  func hideLoading() {
    baseViewController?.hideLoader()
  }
  
}
