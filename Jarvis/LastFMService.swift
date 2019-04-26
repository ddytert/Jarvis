//
//  LastFMService.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation
import Alamofire

class LastFMService {
    
    // MARK: - Properties
    static let shared = LastFMService(baseURL: URL(string: Constants.URL.LastFM)!)
    
    // MARK: -
    let baseURL: URL
    
    // Initialization
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func searchForArtist(_ artistName: String, completion: @escaping ([Artist]?, String) -> Void) {
        
        Alamofire.request("http://ws.audioscrobbler.com/2.0/",
                          parameters: ["method": "artist.search",
                                       "limit": 100,
                                       "artist": artistName,
                                       "api_key": lastfmAuthKey,
                                       "format": "json"])
            .responseData { response in
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching artists: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ArtistSearchResults.self, from: data)
                    let artists = searchResult.results.artistMatches.artists
                    let numberResults = Int(searchResult.results.count) ?? 0
                    let successMessage = "\(numberResults) artists found"
                    completion(artists, successMessage)
                    return
                } catch {
                    let errorMessage = "Error while fetching artists: \(String(describing: response.result.error))"
                    completion(nil, errorMessage)
                    return
                }
        }
    }
}
