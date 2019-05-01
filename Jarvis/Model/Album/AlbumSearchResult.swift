//
//  AlbumSearchResult.swift
//  Jarvis
//
//  Created by Daniel Dytert on 27.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

/// Hierarchical data model which corresponds to search result returned from lastfm (get album details)

import Foundation

struct AlbumSearchResults: Decodable {
    let album: Album
}
