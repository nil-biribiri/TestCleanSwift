//
//  BaseScreen.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import XCTest

class BaseScreen<E: RawRepresentable> where E.RawValue == String {
  
  func setContext(name: E, activity: (() -> ())) {
    synced(self) {
      XCTContext.runActivity(named: name.rawValue) { _ in
        activity()
      }
    }
  }

  func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
  }
}
