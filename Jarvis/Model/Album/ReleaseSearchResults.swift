//
//  TopAlbumSearchResults.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Hierarchical data model which corresponds to search result returned from lastfm (get artists topalbums)

import Foundation

struct ReleaseSearchResults: Decodable {
    let releases: [Release]
    let pagination: Pagination
}
/*
{
    "pagination": {
        "per_page": 50,
        "pages": 48,
        "page": 1,
        "urls": {
            "last": "https:\/\/api.discogs.com\/artists\/25261\/releases?sort=year&per_page=50&secret=hlxKzbtTVIdTsKdFCsHRMJIaEsdLpPrJ&page=48&key=hssapXpogmUQyvHDmMnr",
            "next": "https:\/\/api.discogs.com\/artists\/25261\/releases?sort=year&per_page=50&secret=hlxKzbtTVIdTsKdFCsHRMJIaEsdLpPrJ&page=2&key=hssapXpogmUQyvHDmMnr"
        },
        "items": 2366
    },
    "releases": [
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
}
*/
