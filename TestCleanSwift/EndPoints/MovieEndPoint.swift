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
    case GetMovieTrailer(movieId: String)
}

extension FetchMovieEndPoint: ServiceEndpoint {

    var parameters: Codable?{
        switch self {
        case .FetchMovieList, .GetMovieTrailer:
            return nil
        }
    }

    var baseURL: URL {
        switch self {
        case .FetchMovieList, .GetMovieTrailer:
            return URL(string: Config.baseAPI)!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .FetchMovieList, .GetMovieTrailer:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .FetchMovieList:
            return "/discover/movie"
        case .GetMovieTrailer(let movieId):
            return "/movie/\(movieId)/videos"
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .FetchMovieList(let page):
            return ["api_key" : Config.APIKeys,
                    "language" : "en-US",
                    "sort_by" : "popularity.desc",
                    "page" : page ]
        case .GetMovieTrailer:
            return ["api_key" : Config.APIKeys]
        }
    }

}
