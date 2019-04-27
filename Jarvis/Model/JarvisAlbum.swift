//
//  JarvisAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

/// Album data model which corresponds to lastfms json representation of an album

class JarvisAlbum: Decodable {
    let title: String
    let images: [AlbumImage]
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case images = "image"
        case url
    }
}

struct AlbumImage: Decodable {
    let imageURL: String
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "#text"
        case size
    }
}
