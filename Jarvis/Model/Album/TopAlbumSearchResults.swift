//
//  TopAlbumSearchResults.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Hierarchical data model which corresponds to search result returned from lastfm (get artists topalbums)

import Foundation

struct TopAlbumSearchResults: Decodable {
    let topAlbums: TopAlbums
    
    private enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
}

struct TopAlbums: Decodable {
    let albums: [TopAlbum]
    let attributes: Attributes
    
    private enum CodingKeys: String, CodingKey {
        case albums = "album"
        case attributes = "@attr"
    }
}

struct Attributes: Decodable {
    let total: String
}

