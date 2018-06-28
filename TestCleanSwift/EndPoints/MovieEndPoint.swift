//
//  MovieEndPoint.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 27/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct SecureRequestGenerator : RequestGenerator {
  func generateRequest(method: HTTPMethod) -> MutableRequest {
    return request(withMethod: method) |> withJsonSupport
  }
}

enum FetchMovieEndPoint {
  case FetchMovieList(page: String)
}

extension FetchMovieEndPoint : ServiceEndpoint {

  var baseURL: URL {
    get {
      return URL(string: Config.baseAPI)!
    }
  }
  
  var method: HTTPMethod {
    get {
      return .GET
    }
  }
  
  var path: String {
    switch self {
    case .FetchMovieList:
      return "/discover/tv"
    }
  }
  
  var requestGenerator: RequestGenerator {
    get {
      return SecureRequestGenerator()
    }
  }
  
  var queryParameters: [String : String]? {
    switch self {
    case .FetchMovieList(let page):
      return ["api_key" : Config.APIKeys, "language" : "en-US", "sort_by" : "popularity.desc", "page" : page ]
    }
  }
}
