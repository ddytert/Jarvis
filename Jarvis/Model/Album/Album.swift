//
//  DetailedAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let artist: String
    let title: String
    let imageInfos: [ImageInfo]
    let tracks: Tracks
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case title = "name"
        case imageInfos = "image"
        case tracks
        case url
    }
}
// Due to the strange json format received from lastfm we need an outer 'Tracks' struct
struct Tracks: Decodable {
    let tracks: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case tracks = "track"
    }
}

struct ImageInfo: Decodable {
    let url: String
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}
