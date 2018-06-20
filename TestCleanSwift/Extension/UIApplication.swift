//
//  UIApplication.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 15/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication{
  var topViewController: UIViewController?{
    if keyWindow?.rootViewController == nil{
      return keyWindow?.rootViewController
    }
    
    var pointedViewController = keyWindow?.rootViewController
    
    while  pointedViewController?.presentedViewController != nil {
      switch pointedViewController?.presentedViewController {
      case let navagationController as UINavigationController:
        pointedViewController = navagationController.viewControllers.last
      case let tabBarController as UITabBarController:
        pointedViewController = tabBarController.selectedViewController
      default:
        pointedViewController = pointedViewController?.presentedViewController
      }
    }
    return pointedViewController
    
  }
}
