//
//  CustomSwizzle.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 25/7/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

private func _swizzleMethod(_ class_: AnyClass, from originalSelector: Selector, to swizzleSelector: Selector, isClassMethod: Bool)
{
  let c: AnyClass
  if isClassMethod {
    c = object_getClass(class_)!
  }
  else {
    c = class_
  }

  guard let originalMathod: Method = class_getInstanceMethod(c, originalSelector),
    let swizzleMethod: Method = class_getInstanceMethod(c, swizzleSelector)
    else {
      fatalError("Swizzle fail, cannot get instance method.")
  }

  if class_addMethod(c, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod)) {
    class_replaceMethod(c, swizzleSelector, method_getImplementation(originalMathod), method_getTypeEncoding(originalMathod))
  }
  else {
    method_exchangeImplementations(originalMathod, swizzleMethod)
  }
}

/// Instance-method swizzling.
public func swizzleInstanceMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
  _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: false)
}

/// Instance-method swizzling for unsafe raw-string.
/// - Note: This is useful for non-`#selector`able methods e.g. `dealloc`, private ObjC methods.
public func swizzleInstanceMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
  swizzleInstanceMethod(class_, from: Selector(sel1), to: Selector(sel2))
}

/// Class-method swizzling.
public func swizzleClassMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
  _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: true)
}

/// Class-method swizzling for unsafe raw-string.
public func swizzleClassMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
  swizzleClassMethod(class_, from: Selector(sel1), to: Selector(sel2))
}

extension MainViewController {
  
  @objc dynamic func swizzleCellForRow() {
    self.swizzleCellForRow()
  }

//  @objc dynamic func swizzleSetup() {
//    swizzleSetup()
//    self.title = "Swizzle Title!!!"
//  }
}
