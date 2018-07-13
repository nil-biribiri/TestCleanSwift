//
//  MovieEndPoint.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 27/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation
import NilNetzwerk

enum FetchMovieEndPoint {
  case FetchMovieList(page: String)
  case testPost(name: String, job: String)
  case testError
}

extension FetchMovieEndPoint: ServiceEndpoint {

  var parameters: Codable?{
    switch self {
    case .FetchMovieList:
      return nil
    case .testPost(let name, let job):
      return testPostModel(name: name, job: job)
    case .testError:
      return nil
    }
  }

  var baseURL: URL {
    switch self {
    case .FetchMovieList:
      return URL(string: Config.baseAPI)!
    case .testPost, .testError:
      return URL(string: "https://reqres.in/api")!
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .FetchMovieList, .testError:
      return .GET
    case .testPost:
      return .POST
    }
  }
  
  var path: String {
    switch self {
    case .FetchMovieList:
      return "/discover/tv"
    case .testPost:
      return "/users"
    case .testError:
      return "/api/unknown/23"
    }
  }
  
  var queryParameters: [String : String]? {
    switch self {
    case .FetchMovieList(let page):
      return ["api_key" : Config.APIKeys, "language" : "en-US", "sort_by" : "popularity.desc", "page" : page ]
    case .testPost, .testError:
      return nil
    }
  }
}

struct testPostModel: Codable {
  let name: String
  let job: String
}
