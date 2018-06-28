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
    return self.exists && self.isHittable && self.isEnabled
  }
}
