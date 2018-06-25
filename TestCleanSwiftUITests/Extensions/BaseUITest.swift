//
//  BaseUITest.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 22/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import XCTest

class BaseUITest: XCTestCase {
  var app: XCUIApplication!

  override func setUp() {
    super.setUp()

    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("--uitesting")
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func setContext(name: XCContextConfig, activity: (() -> ())) {
    XCTContext.runActivity(named: name.rawValue) { _ in
      activity()
    }
  }

  func startApp() {
    setContext(name: .startApp) {
      app.launch()
    }
  }

  func takeScreenshot(with context: XCContextConfig) {
    setContext(name: context) {
      let screenshot = app.windows.firstMatch.screenshot()
      let attachment = XCTAttachment(screenshot: screenshot)
      attachment.lifetime = .keepAlways
      add(attachment)
    }
  }

}
