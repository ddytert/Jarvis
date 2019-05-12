//
//  ImageInfo.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

struct Pagination: Decodable {
    let perPage: Int
    let items: Int
    let page: Int
    let pages: Int
    
    private enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case items
        case page
        case pages
    }
}
