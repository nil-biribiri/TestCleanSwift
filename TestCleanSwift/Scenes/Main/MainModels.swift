//
//  MainModels.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 25/5/2561 BE.
//  Copyright (c) 2561 NilNilNil. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Main {
  // MARK: Use cases
  
  enum Something {
    struct Request {
      var loadingIndicator: Bool
    }
    struct Response {
      var movieList: MovieList
    }
    struct Error {
      var error: NetworkErrorResponse
    }
    struct ViewModel {
      struct Movie {
        let movieTitle: String
        let movieRating: String
        let moviePosterPath: String
      }
      var movieList: [Movie]
    }
  }
}
