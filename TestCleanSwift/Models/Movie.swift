//
//  Movie.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 28/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct MovieList: Codable, Equatable {
  var movies: [Movie]
  let page: Int

  enum CodingKeys: String, CodingKey {
    case movies = "results"
    case page
  }
}

struct Movie: Codable, Equatable {
  let name: String
  let voteAverage: Double
  let posterPath: String
  let overview: String

  init(name: String,
       voteAverage: Double,
       posterPath: String,
       overview: String) {
    self.name = name
    self.voteAverage = voteAverage
    self.posterPath = posterPath
    self.overview = overview
  }
  
  init(from decoder: Decoder) throws {
    let container         = try decoder.container(keyedBy: CodingKeys.self)
    
    name                  = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    voteAverage           = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
    posterPath            = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
    overview              = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
  }
}
