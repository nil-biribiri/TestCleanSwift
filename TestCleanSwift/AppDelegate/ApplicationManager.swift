//
//  ApplicationManager.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 19/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import UIKit

class ApplicationManager {

  // MARK: - Variable
  static let sharedInstance = ApplicationManager()

  func initAllSDKs() {

  }

  func initCommon(window: UIWindow?) {
    self.initGlobalAppearance()
    self.setRootVC(window: window)
  }

}


private extension ApplicationManager {
  func initGlobalAppearance() {
    UIApplication.shared.statusBarStyle = .lightContent
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().backgroundColor = .clear
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
  }
  func setRootVC(window: UIWindow?) {
    window?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
  }
}
