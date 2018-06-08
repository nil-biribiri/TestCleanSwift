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

class MainWorker {
  func doSomeWork(completion: @escaping (Result<(MovieList)>) -> Void) {
    
    let requestURL = "https://api.themoviedb.org/3/discover/movie?page=1&include_video=false&include_adult=false&sort_by=popularity.desc&language=en-US&api_key=e2889e1e96107371259d511ce3c23f8b"
    
    NetworkClient.request(url: requestURL,
                          params: nil,
                          paramsType: MovieList.self,
                          method: HTTPMethod.get,
                          headers: nil,
                          resultType: MovieList.self) { (result) in
                            DispatchQueue.main.async {
                              completion(NetworkBaseService.transformServiceResponse(result))
                            }
    }
  }
}
