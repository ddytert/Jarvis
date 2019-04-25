//
//  LastFMAlbum.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

class Album {
    
    let lastfmID: String
    let name: String
    let artist: String
    let tracks: [Track]
    let imageURL: String
    let year: Int
    var image: UIImage?
    
    init (lastfmID: String, name: String, artist: String, year: Int,
          tracks: [Track], imageURL: String, image: UIImage?) {
        self.lastfmID = lastfmID
        self.name = name
        self.artist = artist
        self.year = year
        self.tracks = tracks
        self.imageURL = imageURL
        self.image = image
    }
}
