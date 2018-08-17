//
//  APIs.swift
//  TestCleanSwift
//
//  Created by Tanasak Ngerniam on 10/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

struct APIs {
    private init() {}

    struct downloadImage {
        private init() {}
        enum imageSize: String {
            case thumbnail  = "/w200"
            case original   = "/original"
        }
        static func loadImage(withSize size: imageSize, withPath posterPath: String) -> String {
            return Config.baseImageAPI + size.rawValue + posterPath
        }
    }

    struct youtubeLink {
        private init() {}
        static func generateWithId(id: String?) -> String? {
            if let unwrappedId = id {
                return Config.baseYoutubeAPI + unwrappedId + "?playsinline=1"
            } else {
                return nil
            }
        }
    }

}
