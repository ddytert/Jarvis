//
//  AlbumImage.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct AlbumImageInfo: Decodable {
    let url: String
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}
