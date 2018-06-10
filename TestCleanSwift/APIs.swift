//
//  APIs.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 10/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct APIs {
  private init() {}

  struct fetchSeriesList {
    private init() {}
    static func fectchSeries(withPage page: String) -> String {
      return Config.baseAPI + "/discover/tv?api_key=\(Config.APIKeys)&language=en-US&sort_by=popularity.desc&page=\(page)"
    }
  }

}
