//
//  Release.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct Release: Decodable {
    let title: String
    let id: Int
    var type: String?
    var artist: String?
    var artists: [ReleaseArtist]?
    var year: Int?
    var thumbURL: String?
    var images: [Image]?
    var tracklist: [Track]?
    var genres: [String]?

    private enum CodingKeys: String, CodingKey {
        case title
        case id
        case type
        case artist
        case artists
        case year
        case thumbURL = "thumb"
        case images
        case tracklist
        case genres
    }
}

struct ReleaseArtist: Decodable {
    let name: String
    let id: Int
}

struct Image: Decodable {
    let uri: String
    let type: String
}

//{
//    "uri": "",
//    "height": 600,
//    "width": 600,
//    "resource_url": "",
//    "type": "primary",
//    "uri150": ""
//},

/*
{
    "stats": {
        "community": {
            "in_collection": 45,
            "in_wantlist": 55
        }
    },
    "thumb": "https:\/\/img.discogs.com\/bspHccEB5nt9ibR0vi0tGrjgTqU=\/fit-in\/150x150\/filters:strip_icc():format(jpeg):mode_rgb():quality(40)\/discogs-images\/R-2250832-1272988928.jpeg.jpg",
    "title": "A Lover's Hideaway \/ I\u2019ll Be Good To You",
    "main_release": 2250832,
    "artist": "Al Greene*",
    "role": "Main",
    "year": 1967,
    "resource_url": "https:\/\/api.discogs.com\/masters\/1143216",
    "type": "master",
    "id": 1143216
}
 */
