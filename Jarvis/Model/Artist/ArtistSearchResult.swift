//
//  ArtistSearchResult.swift
//  Jarvis
//
//  Created by Daniel Dytert on 25.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Hierarchical data model which corresponds to search result returned from lastfm


import Foundation


struct ArtistSearchResult: Decodable {
    let results: [Artist]
    let pagination: Pagination
}


//{
//    "pagination": {
//        "per_page": 50,
//        "items": 1837,
//        "page": 1,
//        "urls": {
//            "last": "https:\/\/api.discogs.com\/database\/search?q=Raphael&secret=hlxKzbtTVIdTsKdFCsHRMJIaEsdLpPrJ&key=hssapXpogmUQyvHDmMnr&per_page=50&type=artist&page=37",
//            "next": "https:\/\/api.discogs.com\/database\/search?q=Raphael&secret=hlxKzbtTVIdTsKdFCsHRMJIaEsdLpPrJ&key=hssapXpogmUQyvHDmMnr&per_page=50&type=artist&page=2"
//        },
//        "pages": 37
//    },
//    "results": [
//    {
//    "thumb": "https:\/\/img.discogs.com\/1kSI6vxnY5AWPRPq6FJ21QqiTkU=\/150x150\/smart\/filters:strip_icc():format(jpeg):mode_rgb():quality(40)\/discogs-images\/A-408215-1184794906.jpeg.jpg",
//    "title": "Mickey Raphael",
//    "uri": "\/artist\/408215-Mickey-Raphael",
//    "master_url": null,
//    "cover_image": "https:\/\/img.discogs.com\/Uhm3LLugPq5m1ts4mrWwgU-dpxY=\/335x480\/smart\/filters:strip_icc():format(jpeg):mode_rgb():quality(90)\/discogs-images\/A-408215-1184794906.jpeg.jpg",
//    "resource_url": "https:\/\/api.discogs.com\/artists\/408215",
//    "master_id": null,
//    "type": "artist",
//    "id": 408215
//    }
//}
