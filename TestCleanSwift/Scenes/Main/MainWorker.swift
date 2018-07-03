//
//  MainWorker.swift
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

class TestHttpClient: HTTPClient {

  let lock = NSLock()

  override func handleUnauthorized() {
    lock.lock()
    let request = Request(endpoint: TokenEndPoint.getToken)
    HTTPClient.shared.executeRequest(request: request) { (result: Result<TokenResponse>) in
      self.lock.unlock()
      switch result {
      case .success(let response):
        TokenResponse.shared = response.bodyObject
        while !self.requestsToRetry.isEmpty {
          let request = self.requestsToRetry.dequeue()
          request?()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  override func adapter(request: inout Request) {
    request.updateHTTPHeaderFields(headerFields: [Constants.Authorization : "\(TokenResponse.shared.tokenType) \(TokenResponse.shared.accessToken)"])
  }
}

class MainWorker {
  func fetchList(page: String, completion: @escaping (Result<(MovieList)>) -> Void) {
    let request = Request(endpoint: FetchMovieEndPoint.FetchMovieList(page: page))
    HTTPClient.shared.executeRequest(request: request) { (result: Result<MovieList>) in
      completion(result)
    }


//    let requestURL = APIs.fetchSeriesList.fectchSeries(withPage: page)


//    NetworkClient.request(url: requestURL,
//                          params: nil,
//                          paramsType: MovieList.self,
//                          method: HTTPMethod.get,
//                          headers: nil,
//                          resultType: MovieList.self) { (result) in
//                            DispatchQueue.main.async {
//                              completion(NetworkBaseService.transformServiceResponse(result))
//                            }
//    }
  }

  static func testPost() {
    let request = Request(endpoint: FetchMovieEndPoint.testPost(name: "Yo!", job: "iOS"))
    HTTPClient.shared.executeRequest(request: request) { (result: Result<testPostModel>) in
    }
  }

  static func testError() {
    let httpClient = TestHttpClient()
    let request = Request(endpoint: ActivateEndPoint.activate)
    httpClient.executeRequest(request: request) { (result: Result<EDCActivateResponse>) in
      switch result {
      case .success(let response):
        print(response)
      case .failure(let error):
        print(error)
      }
    }
  }

}
