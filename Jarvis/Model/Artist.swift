//
//  Artist.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation

class Artist {
    
    let lastfmID: String
    let name: String
    let albums: [Album]?
    
    init (lastfmID: String, name: String, albums: [Album]) {
        self.lastfmID = lastfmID
        self.name = name
        self.albums = albums
    }
}
