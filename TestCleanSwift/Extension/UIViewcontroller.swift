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

}

extension UIViewController {
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
}
