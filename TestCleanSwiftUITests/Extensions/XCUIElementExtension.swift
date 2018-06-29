//
//  XCUIElementExtension.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 25/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
  /// Whether or not the element is exists, hitable, enabled for user interaction.
  var isExitsHitableEnabled: Bool {
    return self.exists && self.isHittable
  }
  
  func scrollToElement(element: XCUIElement) {
    while !element.visible() {
      swipeUp()
    }
  }

  func visible() -> Bool {
    guard self.exists && !self.frame.isEmpty else { return false }
    return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
  }


  enum direction : Int {
    case Up, Down, Left, Right
  }

  func gentleSwipe(_ direction : direction) {
    let half : CGFloat = 0.5
    let adjustment : CGFloat = 0.25
    let pressDuration : TimeInterval = 0.05

    let lessThanHalf = half - adjustment
    let moreThanHalf = half + adjustment

    let centre = self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: half))
    let aboveCentre = self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: lessThanHalf))
    let belowCentre = self.coordinate(withNormalizedOffset: CGVector(dx: half, dy: moreThanHalf))
    let leftOfCentre = self.coordinate(withNormalizedOffset: CGVector(dx: lessThanHalf, dy: half))
    let rightOfCentre = self.coordinate(withNormalizedOffset: CGVector(dx: moreThanHalf, dy: half))

    switch direction {
    case .Up:
      centre.press(forDuration: pressDuration, thenDragTo: aboveCentre)
      break
    case .Down:
      centre.press(forDuration: pressDuration, thenDragTo: belowCentre)
      break
    case .Left:
      centre.press(forDuration: pressDuration, thenDragTo: leftOfCentre)
      break
    case .Right:
      centre.press(forDuration: pressDuration, thenDragTo: rightOfCentre)
      break
    }
  }
}

