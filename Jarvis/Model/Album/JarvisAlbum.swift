//
//  JarvisAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

/// Album data model which corresponds to lastfms json representation of an album

struct JarvisAlbum: Decodable {
    let title: String
    let imageInfos: [ImageInfo]
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "name"
        case imageInfos = "image"
        case url
    }
}
