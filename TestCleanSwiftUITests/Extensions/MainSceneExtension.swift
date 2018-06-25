//
//  MainSceneExtension.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 22/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import XCTest

extension MainSceneUITests {

  var timeOut: Double {
    return 10.0
  }

  var navigationBar: XCUIElement {
    return app.navigationBars["MainScene.Title"].firstMatch
  }

  var movieTableView: XCUIElement {
    return app.tables["MainScene.MainMovieTableView"].firstMatch
  }

  var movieTableViewCell: XCUIElement {
    return movieTableView.cells.element(matching: .cell, identifier: "mainCell_0").firstMatch
  }

  var movieTableViewCellNameLabel: XCUIElement {
    return movieTableViewCell.staticTexts.element(matching: .any, identifier: "mainCell.movieNameLabel").firstMatch
  }

  var movieTableViewCellRateLabel: XCUIElement {
    return movieTableViewCell.staticTexts.element(matching: .any, identifier: "mainCell.movieRateLabel").firstMatch
  }


  func checkMainSceneAppearance() {
    setContext(name: .checkMainScene) {
      XCTAssertTrue(navigationBar.exists)
    }
  }

  func checkTableViewAppearance() {
    setContext(name: .checkMovieTableView) {
      _ = movieTableView.waitForExistence(timeout: timeOut)
      XCTAssertTrue(movieTableView.exists)
    }
  }

  func checkTableViewCellAppearance() {
    setContext(name: .checkMovieTableViewCell) {
      _ = movieTableViewCell.waitForExistence(timeout: timeOut)
      XCTAssertTrue(movieTableViewCell.exists)
      XCTAssertTrue(movieTableViewCellNameLabel.exists)
      XCTAssertTrue(movieTableViewCellRateLabel.exists)
    }
  }

}
