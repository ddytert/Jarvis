//
//  LastFMService.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

final class LastFMService {
    
    // MARK: - Properties
    // Return singleton instance
    public static let shared = LastFMService()
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    // Initialization
    private init() {
    }
    
    public func searchForArtist(_ artistName: String,
                                completion: @escaping ([Artist]?, String) -> Void) {
        
        Alamofire.request(Constants.URL.LastFM,
                          parameters: ["method": "artist.search",
                                       "limit": 300,
                                       "artist": artistName,
                                       "api_key": Constants.Key.LastFMAPI,
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
                    let numberResults = Int(searchResult.results.total) ?? 0
                    let successMessage = "\(numberResults) artists found"
                    completion(artists, successMessage)
                    return
                } catch {
                    let errorMessage = "Error: JSON decoding failed"
                    completion(nil, errorMessage)
                    return
                }
        }
    }
    
    public func fetchTopAlbumsOfArtist(_ artistName: String,
                                       completion: @escaping ([TopAlbum]?, String) -> Void) {
        
        Alamofire.request(Constants.URL.LastFM,
                          parameters: ["method": "artist.getTopAlbums",
                                       "limit": 300,
                                       "artist": artistName,
                                       "api_key": Constants.Key.LastFMAPI,
                                       "format": "json"])
            .responseData { response in
                
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching albums: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(TopAlbumSearchResults.self, from: data)
                    let albums = searchResult.topAlbums.albums
                    let numberResults = Int(searchResult.topAlbums.attributes.total) ?? 0
                    if numberResults > 0 {
                        let successMessage = "\(numberResults) albums found"
                        completion(albums, successMessage)
                        return
                    } else {
                        let errorMessage = "No albums found"
                        completion(nil, errorMessage)
                        return
                    }
                } catch {
                    let errorMessage = "Error: JSON decoding failed"
                    completion(nil, errorMessage)
                    return
                }
        }
    }
    
    public func fetchDetailsForAlbum(_ albumTitle: String,
                                     _ artistName: String,
                                     completion: @escaping (Album?, String) -> Void) {
        
        Alamofire.request(Constants.URL.LastFM,
                          parameters: ["method": "album.getInfo",
                                       "limit": 300,
                                       "album": albumTitle,
                                       "artist": artistName,
                                       "api_key": Constants.Key.LastFMAPI,
                                       "format": "json"])


            .responseData { response in

                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching album details: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(AlbumSearchResults.self, from: data)
                    let album = searchResult.album
                    completion(album, "Success")
                } catch {
                    let errorMessage = "Error: JSON decoding failed"
                    completion(nil, errorMessage)
                    return
                }
        }
    }
    
    // MARK: Image fetching
    
    public func imageForURL(_ urlString: String,
                            completion: @escaping (UIImage?) -> Void) {
        
        // First check if image is already stored in the cache
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            print("Image already in cache!")
            completion(image)
            return
        }
        // Image isn't stored yet so retrieve it from server
        Alamofire.request(urlString).responseImage { response in
            //debugPrint(response)
            if let image = response.result.value {
                print("image downloaded: \(image)")
                // Store image in cache
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                completion(image)
            }
        }
    }
    
    public func cachedImageForURL(_ urlString: String) -> UIImage? {
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
