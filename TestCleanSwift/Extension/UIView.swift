//
//  UIView.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 17/8/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func layoutAttachAll(to parentView:UIView) {
        var constraints = [NSLayoutConstraint]()
        self.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(NSLayoutConstraint(item: self,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: parentView,
                                              attribute: .left,
                                              multiplier: 1.0,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: self,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: parentView,
                                              attribute: .right,
                                              multiplier: 1.0,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: self,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: parentView,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: self,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: parentView,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0))
        parentView.addConstraints(constraints)
    }
}
