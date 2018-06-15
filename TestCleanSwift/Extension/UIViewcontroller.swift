//
//  UIViewcontroller.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 5/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {}

extension UIViewController {
  var loading: UIViewController {
    let viewController = UIViewController()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.startAnimating()
    viewController.view.addSubview(indicator)
    
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(
        equalTo: viewController.view.centerXAnchor
      ),
      indicator.centerYAnchor.constraint(
        equalTo: viewController.view.centerYAnchor
      )
      ])
    
    return viewController
  }
  
  func add(_ child: UIViewController) {
    addChildViewController(child)
    self.view.layoutIfNeeded()
    child.view.frame = view.bounds
    view.addSubview(child.view)
    child.didMove(toParentViewController: self)
  }
  
  func remove() {
    guard parent != nil else {
      return
    }
    
    willMove(toParentViewController: nil)
    removeFromParentViewController()
    view.removeFromSuperview()
  }
  
  func showInfoAlert(title: String? = "", message: String? = "", buttonTitle: String? = "OK", handler: ((UIAlertAction) -> Void)? = nil){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    if (buttonTitle != nil) {alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: {
      handler
    }()))
    }
    self.present(alert, animated: true, completion: nil)
  }
  
  func showConfirmAlert(title: String? = "", message: String? = "", buttonTitle1: String? = "OK", buttonTitle2: String? = "Cancel", handler1: ((UIAlertAction) -> Void)? = nil, handler2: ((UIAlertAction) -> Void)? = nil){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: buttonTitle1, style: UIAlertActionStyle.default, handler: {
      handler1
    }()))
    alert.addAction(UIAlertAction(title: buttonTitle2, style: UIAlertActionStyle.default, handler: {
      handler2
    }()))
    self.present(alert, animated: true, completion: nil)
  }
  
}
