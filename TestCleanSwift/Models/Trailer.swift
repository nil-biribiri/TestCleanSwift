//
//  Trailer.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 17/8/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct TrailerList: Codable, Equatable {
    let id: Int?
    let results: [Trailer]?
}


struct Trailer: Codable, Equatable {
    let id: String?
    let key: String?
    let site: String?
    let type: String?
}
