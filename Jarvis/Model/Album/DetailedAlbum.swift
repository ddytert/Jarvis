//
//  DetailedAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct DetailedAlbum: Decodable {
    let artist: String
    let title: String
    let images: [AlbumImage]
    let tracks: Tracks
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case artist
        case title = "name"
        case images = "image"
        case tracks
        case url
    }
}
// Due to the strange json format we need an outer 'Tracks' object
struct Tracks: Decodable {
    let tracks: [AlbumTrack]
    
    private enum CodingKeys: String, CodingKey {
        case tracks = "track"
    }
}
