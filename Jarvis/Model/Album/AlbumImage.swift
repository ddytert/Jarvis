//
//  AlbumImage.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct AlbumImage: Decodable {
    let imageURL: String
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "#text"
        case size
    }
}
