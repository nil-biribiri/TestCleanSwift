//
//  Movie.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 28/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation


struct MovieList: Codable {
  var movies: [Movie]
  let page: Int

  enum CodingKeys: String, CodingKey {
    case movies = "results"
    case page
  }
  
}

struct Movie: Codable {
  let name: String
  let voteAverage: Double
  let posterPath: String
  let overview: String
//  enum DataCodingKeys: String, CodingKey {
//    case results
//  }
//  
//  init(from decoder: Decoder) throws {
//    let data              = try decoder.container(keyedBy: DataCodingKeys.self)
//    let container         = try data.nestedContainer(keyedBy:CodingKeys.self, forKey: .results)
//    
//    title                 = try container.decode(String.self, forKey: .title)
//    voteAverage           = try container.decode(Double.self, forKey: .voteAverage)
//    posterPath            = try container.decode(String.self, forKey: .posterPath)
//
//  }
  
}
