//
//  BaseTestCase.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import XCTest

class BaseTestCase: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    super.setUp()

    continueAfterFailure = false
    app = XCUIApplication()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func setContext(name: BaseContext, activity: (() -> ())) {
    XCTContext.runActivity(named: name.rawValue) { _ in
      activity()
    }
  }

  func resetApp() {
    setContext(name: .firstLaunch) {
      app.launchArguments.append("--uitesting")
      app.launch()
    }
  }


  func takeScreenshot(of context: ScreenContext) {
    XCTContext.runActivity(named: context.rawValue) { _ in
      let screenshot = app.windows.firstMatch.screenshot()
      let attachment = XCTAttachment(screenshot: screenshot)
      attachment.lifetime = .keepAlways
      add(attachment)
    }
  }
}
