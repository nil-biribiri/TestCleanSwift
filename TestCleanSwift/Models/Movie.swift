//
//  Movie.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 28/5/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct MovieList: Codable, Equatable {
    var movies: [Movie?]
    let page: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
    }

}

struct Movie: Codable, Equatable {
    let title: String
    let id: Int
    let voteAverage: Double
    let posterPath: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case voteAverage = "vote_average"
        case posterPath  = "poster_path"
        case overview
    }

    init(title: String,
         id: Int,
         voteAverage: Double,
         posterPath: String,
         overview: String) {
        self.title = title
        self.id = id
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.overview = overview
    }

    init(from decoder: Decoder) throws {
        let container         = try decoder.container(keyedBy: CodingKeys.self)

        title                 = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        id                    = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        voteAverage           = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        posterPath            = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        overview              = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
    }
}
