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

  struct downloadImage {
    private init() {}
    enum imageSize: String {
      case thumbnail  = "/w200"
      case original   = "/original"
    }
    static func loadImage(withSize size: imageSize, withPath posterPath: String) -> String {
      return Config.baseImageAPI + size.rawValue + posterPath
    }
  }
  
}
