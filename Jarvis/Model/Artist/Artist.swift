//
//  Artist.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Artist data model which corresponds to lastfms json representation of an artist


import Foundation


class Artist: Decodable {
    let name: String
    let thumbURL: String
    let imageURL: String
    let url: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case name = "title"
        case thumbURL = "thumb"
        case imageURL = "cover_image"
        case url = "resource_url"
        case id
    }
}



/*
"thumb": "",
"title": "Raphael (19)",
"uri": "\/artist\/2235371-Raphael-19",
"master_url": null,
"cover_image": "https:\/\/img.discogs.com\/9fa42e92ed5be1e53e98fd57aec8732bbe8f9a7f\/images\/spacer.gif",
"resource_url": "https:\/\/api.discogs.com\/artists\/2235371",
"master_id": null,
"type": "artist",
"id": 2235371
*/
