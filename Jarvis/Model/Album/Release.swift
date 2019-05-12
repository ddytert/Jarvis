//
//  TopAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// 'Light' Album data model which corresponds to lastfms json representation of an album (returned by search for an artists top albums)

import Foundation

struct Release: Decodable {
    let title: String
    let thumbURL: String
    let artist: String
    let id: Int
    var year: Int?


    private enum CodingKeys: String, CodingKey {
        case title
        case thumbURL = "thumb"
        case artist
        case id
        case year
    }
}

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
