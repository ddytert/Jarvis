//
//  AlbumStoreReloaded.swift
//  Jarvis
//
//  Created by Daniel Dytert on 29.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Class responsible for persistent storage of user albums and album images

import UIKit
import CoreData


final class UserAlbumStore {
    
    // MARK: - Properties
    // Return singleton instance
    public static let shared = UserAlbumStore()
    
    private var managedContext:NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // Initialization
    private init() {
    }
    
    public func saveAlbum(_ album: Album) {
        
        guard let managedContext = managedContext else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "UserAlbum",
                                                in: managedContext)!
        let userAlbum = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        
        userAlbum.setValue(album.title, forKeyPath: "title")
        userAlbum.setValue(album.artist, forKeyPath: "artist")
        
        let thumbnailImage = getThumbnailImageDataForAlbum(album)
        userAlbum.setValue(thumbnailImage, forKeyPath: "thumbnail")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func getUserAlbums() -> [UserAlbum]? {

        guard let managedContext = managedContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserAlbum")
        
        do {
            let userAlbums = try managedContext.fetch(fetchRequest)
            return userAlbums as? [UserAlbum]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: Helper functions
    private func getThumbnailImageDataForAlbum(_ album: Album) -> Data? {
        
        guard let imageInfo = album.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }),
        let thumbnailImage = LastFMService.shared.imageForURL(imageInfo.url) else { return nil }
        return thumbnailImage.jpegData(compressionQuality: 1.0)
    }
    
}
