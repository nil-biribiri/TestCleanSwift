//
//  MainScreen.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import XCTest

class MainScreen: BaseScreen<MainContext> {
  let app                             : XCUIApplication
  var waitingTime                     : Double
  var mainNavBar                      : XCUIElement
  var mainTableView                   : XCUIElement
  var mainTableViewCell               : XCUIElement
  var mainTableViewLastCell           : XCUIElement
  var mainLoadMoreView                : XCUIElement
  var mainTableViewCellImage          : XCUIElement
  var mainTableViewCellNameLabel      : XCUIElement
  var mainTableViewCellRateLabel      : XCUIElement

  override init() {
    self.app                            = XCUIApplication()
    self.waitingTime                    = 20
    self.mainNavBar                     = app.navigationBars["MainScene.Title"].firstMatch
    self.mainTableView                  = app.tables["MainScene.MainMovieTableView"].firstMatch
    self.mainTableViewCell              = mainTableView.cells.element(boundBy: 0).firstMatch
    self.mainTableViewLastCell          = mainTableView.cells.element(boundBy: mainTableView.cells.count - 1).firstMatch
    self.mainLoadMoreView               = mainTableView.activityIndicators["MainScene.LoadMoreView"].firstMatch
    self.mainTableViewCellImage         = mainTableViewCell.images["mainCell.moviePosterImageView"].firstMatch
    self.mainTableViewCellNameLabel     = mainTableViewCell.staticTexts.element(matching: .any, identifier: "mainCell.movieNameLabel").firstMatch
    self.mainTableViewCellRateLabel     = mainTableViewCell.staticTexts.element(matching: .any, identifier: "mainCell.movieRateLabel").firstMatch
  }

  func checkMainScrennAppearance() -> MainScreen {
    setContext(name: .checkMainView) {
      XCTAssertTrue(mainNavBar.isExitsHitableEnabled)
    }
    return self
  }

  func checkMainTableViewAppearance() -> MainScreen {
    setContext(name: .checkMainTableView) {
      _ = mainTableView.waitForExistence(timeout: waitingTime)
      XCTAssertTrue(mainTableView.exists)
    }
    return self
  }

  func checkMainTableViewCellAppearance() -> MainScreen {
    setContext(name: .checkMainTableViewCell) {
      _ = mainTableViewCell.waitForExistence(timeout: waitingTime)
      XCTAssertTrue(mainTableViewCell.isExitsHitableEnabled)
      _ = mainTableViewCellImage.waitForExistence(timeout: waitingTime)
      XCTAssertTrue(mainTableViewCellImage.isExitsHitableEnabled)
      XCTAssertTrue(mainTableViewCellNameLabel.isExitsHitableEnabled)
      XCTAssertTrue(mainTableViewCellRateLabel.isExitsHitableEnabled)
    }
    return self
  }

  func checkScrollingShowLoadMoreAppearance() -> MainScreen {
    setContext(name: .checkScrollingShowLoadMore) {
      print("Cell: \(mainTableView.cells.count)")
//      let start = mainTableViewCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
//      let finish = mainTableViewCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
//      start.press(forDuration: 1, thenDragTo: finish)

//      while true {
//        mainTableView.swipeUp()
//        if mainLoadMoreView.exists { break }
////        if app.windows.element(boundBy: 0).firstMatch.frame.contains(mainLoadMoreView.frame) { break }
//      }
//      XCTAssertTrue(mainTableViewCell.exists)

//      mainTableView.scrollToElement(element: mainLoadMoreView)
    }

    return self
  }
  
//  func expectTutorialDisappear() {
//    _ = setContext(name: .tutorialDisappear) {
//      XCTAssertFalse(carousel.exists)
//      XCTAssertFalse(registerButton.exists)
//      XCTAssertFalse(activateButton.exists)
//      XCTAssertFalse(checkStatusButton.exists)
//      XCTAssertFalse(checkStatusLabel1.exists)
//      XCTAssertFalse(checkStatusLabel2.exists)
//    }
//  }
}
