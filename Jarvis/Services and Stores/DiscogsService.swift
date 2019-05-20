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
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching releases: \(String(describing: response.result.error))"
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
    
    public func fetchDetailsForRelease(_ releaseId: Int,
                                       type: String,
                                       completion: @escaping (Release?, String) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "\(type)s/\(releaseId)",
            parameters: ["key": Constants.Key.Discogs,
                         "secret": Constants.Secret.Discogs],
            headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                guard response.result.isSuccess,
                    let data = response.data else {
                        let errorMessage = "Error while fetching release details: \(String(describing: response.result.error))"
                        completion(nil, errorMessage)
                        return
                }
                do {
                    var release = try JSONDecoder().decode(Release.self,
                                                           from: data)
                    release.type = type
                    completion(release, "Success")
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
