//
//  AlbumStore.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

// TODO: Make class a singleton class

final class AlbumStore {
    
    static func generateAlbumsData() -> [Album] {
        // Album One
        var tracks = [Track(name: "Hold On, Be Strong", length: TimeInterval((1 * 60 + 12))),
                      Track(name: "Return of the 'G'", length: TimeInterval((3 * 60 + 40))),
                      Track(name: "Rosa Parks", length: TimeInterval((4 * 60 + 07))),
                      Track(name: "Aquemini", length: TimeInterval((4 * 60 + 54))),
                      Track(name: "Synthesizer", length: TimeInterval((4 * 60 + 29)))]
        var image = UIImage(named: "OutKast-Aquemini-1537995335-640x634.jpg")
        let albumOne = Album(lastfmID: "08569jevvs83q4tjq4r",
                             name: "Aquemini",
                             artist: "OutKast",
                             year: 1998,
                             tracks: tracks,
                             imageURL: "dkfjgfufdgh.jpg",
                             image: image)
        // Album Two
        tracks = [Track(name: "Waitin' for the Bus", length: TimeInterval((2 * 60 + 59))),
                  Track(name: "Jesus Just Left Chicago", length: TimeInterval((3 * 60 + 30))),
                  Track(name: "Beer Drinkers and Hell Raisers", length: TimeInterval((3 * 60 + 23))),
                  Track(name: "Master of Sparks", length: TimeInterval((3 * 60 + 33))),
                  Track(name: "Hot, Blue and Righteous", length: TimeInterval((3 * 60 + 14))),
                  Track(name: "Move Me on Down the Line", length: TimeInterval((2 * 60 + 32))),
                  Track(name: "Precious and Grace", length: TimeInterval((3 * 60 + 09))),
                  Track(name: "La Grange", length: TimeInterval((3 * 60 + 52))),
                  Track(name: "Shiek", length: TimeInterval((4 * 60 + 05))),
                  Track(name: "Have You Heard?", length: TimeInterval((3 * 60 + 15)))]
        image = UIImage(named: "CS679029-01A-BIG.jpg")
        let albumTwo = Album(lastfmID: "w94hg9495w45",
                             name: "Tres Hombres",
                             artist: "ZZ-Top",
                             year: 1973,
                             tracks: tracks,
                             imageURL: "zztop384u5",
                             image: image)
        // Album Three
        tracks = [Track(name: "And the Gods Made Love", length: TimeInterval((1 * 60 + 21))),
                  Track(name: "Have You Ever Been (To Electric Ladyland)", length: TimeInterval((2 * 60 + 12))),
                  Track(name: "Crosstown Traffic", length: TimeInterval((2 * 60 + 25))),
                  Track(name: "Voodoo Chile", length: TimeInterval((15 * 60 + 05))),
                  Track(name: "Little Miss Strange", length: TimeInterval((2 * 60 + 50))),
                  Track(name: "Long Hot Summer Night", length: TimeInterval((3 * 60 + 30))),
                  Track(name: "Come On", length: TimeInterval((4 * 60 + 10))),
                  Track(name: "Gipsy Eyes", length: TimeInterval((3 * 60 + 46))),
                  Track(name: "Burning of the Midnight Lamp", length: TimeInterval((3 * 60 + 44))),
                  Track(name: "Rainy Day, Dream Away", length: TimeInterval((3 * 60 + 43)))]
        image = UIImage(named: "jimi-hendrix-electric-ladyland-crop-c0-5__0-5-600x600-70.jpg")
        let albumThree = Album(lastfmID: "w94hg9495w45",
                             name: "Electric Ladyland",
                             artist: "Jimi Hendrix",
                             year: 1968,
                             tracks: tracks,
                             imageURL: "jimi3784z5hrg",
                             image: image)
        // Album Four
        tracks = [Track(name: "Little Child Runnin' Wild", length: TimeInterval((5 * 60 + 26))),
                  Track(name: "Pusher Man", length: TimeInterval((5 * 60 + 03))),
                  Track(name: "Freddie's Dead", length: TimeInterval((5 * 60 + 27)))]
        image = UIImage(named: "A1hIUHqDK3L._SS500_.jpg")
        let albumFour = Album(lastfmID: "w94hg9495w45",
                               name: "Superfly",
                               artist: "Curtis Mayfield",
                               year: 1972,
                               tracks: tracks,
                               imageURL: "943z543curtis",
                               image: image)

        
        return [albumOne, albumTwo, albumThree, albumFour]
    }
}
