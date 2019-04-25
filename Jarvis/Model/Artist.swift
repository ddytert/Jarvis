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
    let images: [Image]
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case name
        case images = "image"
        case url
    }
}

struct Image: Decodable {
    let text: String
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}
