//
//  BaseFlow.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import XCTest

class BaseFlow {
  static func setContext(name: BaseContext, activity: (() -> ())) {
    synced(self) {
      XCTContext.runActivity(named: name.rawValue) { _ in
        activity()
      }
    }
  }

  static func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
  }
}
