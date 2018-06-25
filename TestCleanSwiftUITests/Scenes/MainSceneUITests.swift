//
//  TestCleanSwiftUITests.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 21/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import XCTest

class MainSceneUITests: BaseUITest {

  func testMainSceneAppearance() {
    startApp()
    checkMainSceneAppearance()
    checkTableViewAppearance()
    checkTableViewCellAppearance()
  }

  func testMainSceneNavigateToInfo() {
    startApp()
    checkTableViewCellAppearance()
  }

}

extension XCTestCase {

  func waitFor<T>(object: T, timeout: TimeInterval = 5, file: String = #file, line: UInt = #line, expectationPredicate: @escaping (T) -> Bool) {
    let predicate = NSPredicate { obj, _ in
      expectationPredicate(obj as! T)
    }
    expectation(for: predicate, evaluatedWith: object, handler: nil)

    waitForExpectations(timeout: timeout) { error in
      if (error != nil) {
        let message = "Failed to fulful expectation block for \(object) after \(timeout) seconds."
        print(message)
      }
    }
  }

}
