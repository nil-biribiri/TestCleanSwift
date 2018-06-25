//
//  XCContextConfig.swift
//  TestCleanSwiftUITests
//
//  Created by Tanasak.Nge on 22/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

enum XCContextConfig: String {
  case startApp               = "Start application"

  case checkMainScene                       = "Main scene should be displayed"
  case checkMovieTableView                  = "MovieTableView should exists in Main scene"
  case checkMovieTableViewCell              = "MovieTableViewCell should exists in MovieTableView"
}
