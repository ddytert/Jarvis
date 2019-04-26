//
//  SearchResults.swift
//  Jarvis
//
//  Created by Daniel Dytert on 25.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

/// Hierarchical data model which corresponds to search result returned from lastfm

struct ArtistSearchResults: Decodable {
    let results: Results
}

struct Results: Decodable {
    let artistMatches: ArtistMatches
    let count: String
    
    private enum CodingKeys: String, CodingKey {
        case artistMatches = "artistmatches"
        case count = "opensearch:totalResults"
    }
}

struct ArtistMatches: Decodable {
    let artists: [Artist]
    
    private enum CodingKeys: String, CodingKey {
        case artists = "artist"
    }
}
