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
                                completion: @escaping ([Artist]?) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "database/search",
                          method: .get,
                          parameters: ["type": "artist",
                                       "q": artistName,
                                       "key": Constants.Key.Discogs,
                                       "secret": Constants.Secret.Discogs],
                          headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                
                let searchResult: ArtistSearchResult? = self.parseResult(result: response.result)
                completion(searchResult?.results)
                //let numberResults = searchResult.pagination.items
                //let successMessage = "\(numberResults) artists found"
        }
    }
    
    public func fetchReleasesOfArtist(_ artistId: Int,
                                      completion: @escaping ([Release]?) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "artists/\(artistId)/releases",
            parameters: ["sort": "year",
                         "key": Constants.Key.Discogs,
                         "secret": Constants.Secret.Discogs],
            headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                
                let searchResult: ReleaseSearchResults? = self.parseResult(result: response.result)
                completion(searchResult?.releases)
        }
    }
    
    public func fetchDetailsForRelease(_ releaseId: Int,
                                       type: String,
                                       completion: @escaping (Release?) -> Void) {
        
        Alamofire.request(Constants.URL.Discogs + "\(type)s/\(releaseId)",
            parameters: ["key": Constants.Key.Discogs,
                         "secret": Constants.Secret.Discogs],
            headers: ["User-Agent": UserAgentString()])
            .responseData { response in
                
                var release: Release? = self.parseResult(result: response.result)
                release?.type = type
                completion(release)
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
    
    // MARK: Helper method
    
    private func parseResult<T: Decodable>(result: Result<Data>) -> T? {
        
        switch result {
        case .failure(_):
            return nil
        case .success(let data):
            let model = try? JSONDecoder().decode(T.self, from: data)
            return model
        }
    }
}
