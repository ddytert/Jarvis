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

final class DiscogsService {
    
    // MARK: - Properties
    // Return singleton instance
    public static let shared = DiscogsService()
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    // Initialization
    private init() {
    }
    
    public func searchForArtist(_ artistName: String,
                                completion: @escaping ([Artist]?, String) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "database/search",
                          method: .get,
                          parameters: ["type": "artist",
                                       "q": artistName,
                                       "key": Constants.Key.Discogs,
                                       "secret": Constants.Secret.Discogs],
                          headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching artists: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ArtistSearchResult.self,
                                                                from: data)
                    let artists = searchResult.results
                    let numberResults = searchResult.pagination.items
                    let successMessage = "\(numberResults) artists found"
                    completion(artists, successMessage)
                    return
                } catch  let error {
                    completion(nil, error.localizedDescription)
                    return
                }
        }
    }
    
    public func fetchReleasesOfArtist(_ artistId: Int,
                                       completion: @escaping ([Release]?, String) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "artists/\(artistId)/releases",
                          parameters: ["sort": "year",
                                       "key": Constants.Key.Discogs,
                                       "secret": Constants.Secret.Discogs],
                          headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                debugPrint(response.request!)
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching albums: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ReleaseSearchResults.self,
                                                                from: data)
                    let releases = searchResult.releases
                    let numberResults = searchResult.pagination.items
                    if numberResults > 0 {
                        let successMessage = "\(numberResults) releases found"
                        completion(releases, successMessage)
                        return
                    } else {
                        let errorMessage = "No releases found"
                        completion(nil, errorMessage)
                        return
                    }
                } catch  let error {
                    completion(nil, error.localizedDescription)
                    return
                }
        }
    }
    
    public func fetchDetailsForAlbum(_ albumTitle: String,
                                     _ artistName: String,
                                     completion: @escaping (Album?, String) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs,
                          parameters: ["method": "album.getInfo",
                                       "limit": 300,
                                       "album": albumTitle,
                                       "artist": artistName,
                                       "api_key": Constants.Key.Discogs,
                                       "format": "json"])
            .responseData { response in

                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching album details: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(AlbumSearchResults.self,
                                                                from: data)
                    let album = searchResult.album
                    completion(album, "Success")
                } catch let error {
                    completion(nil, error.localizedDescription)
                    return
                }
        }
    }
    
    // MARK: Image fetching
    
    public func imageForURL(_ urlString: String,
                            completion: @escaping (UIImage?) -> Void) {
        
        // First check if image is already stored in the cache
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            completion(image)
            return
        }
        // Image isn't stored yet so retrieve it from server
        Alamofire.request(urlString)
            .responseImage { response in
//            debugPrint(response)
            if let image = response.result.value {
                // Store image in cache
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                completion(image)
            }
        }
    }
    
    public func getCachedImageForURL(_ urlString: String) -> UIImage? {
        if let image = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            return image
        } else {
            return nil
        }
    }
}
