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
  static var swizzledOutIdle = false

  override func setUp() {
    if !BaseTestCase.swizzledOutIdle { // ensure the swizzle only happens once
      let original = class_getInstanceMethod(objc_getClass("XCUIApplicationProcess") as? AnyClass, Selector(("waitForQuiescenceIncludingAnimationsIdle:")))
      let replaced = class_getInstanceMethod(type(of: self), #selector(BaseTestCase.replace))
      method_exchangeImplementations(original!, replaced!)
      BaseTestCase.swizzledOutIdle = true
    }

    super.setUp()

    continueAfterFailure = false
    app = XCUIApplication()
  }
  @objc func replace() {
    return
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
