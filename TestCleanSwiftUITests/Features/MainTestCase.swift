//
//  MainTestCase.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import XCTest

class MainScreenTest: BaseTestCase {

  func testMainScreen() {
    resetApp()
    _ = MainScreen()
      .checkMainScrennAppearance()
      .checkMainTableViewAppearance()
      .checkMainTableViewCellAppearance()
    takeScreenshot(of: .MainScreen)
  }

  func testLoadMore() {
    resetApp()
    _ = MainScreen()
      .checkMainTableViewAppearance()
      .checkScrollingShowLoadMoreAppearance()
  }
  
}
