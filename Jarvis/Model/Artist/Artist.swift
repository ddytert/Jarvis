//
//  Artist.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

/// Artist data model which corresponds to lastfms json representation of an artist

class Artist: Decodable {
    let name: String
    let imageInfos: [ArtistImageInfo]
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case imageInfos = "image"
        case url
    }
}
