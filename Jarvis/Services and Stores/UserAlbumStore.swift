//
//  UserAlbumStore.swift
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
    
    public func saveAlbum(_ album: Album,
                          completion: (Bool, String) -> Void) {
        
        guard let managedContext = managedContext else {
            completion(false, "Missing data store")
            return
        }
        if isAlbumStored(title: album.title, artist: album.artist) {
            completion(false, "Album already saved")
            return
        }
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
            // Inform other objects about successful saving of album
            // (especially MainViewController which then updates its collection view)
            let nc = NotificationCenter.default
            nc.post(name: .didSaveUserAlbum, object: nil)
            
            completion(true, "")
            
        } catch let error as NSError {
            completion(false, "\(error), \(error.userInfo)")
            return
        }
    }
    
    public func deleteAlbum(_ album: UserAlbum) -> Bool {
        
        guard let managedContext = managedContext,
        let title = album.title,
        let artist = album.artist else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAlbum")
        fetchRequest.predicate = NSPredicate(format: "title = %@ AND artist == %@", title, artist)
        fetchRequest.includesSubentities = false

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            return true
        } catch {
            return false
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
    
    public func isAlbumStored(title: String, artist: String) -> Bool {
        
        guard let managedContext = managedContext else { return false }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAlbum")
        fetchRequest.predicate = NSPredicate(format: "title = %@ AND artist == %@", title, artist)
        fetchRequest.includesSubentities = false
                
        var entitiesCount = 0
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        }
        catch {
            return false
        }
        return entitiesCount > 0
    }
    
    // MARK: Helper functions
    private func getThumbnailImageDataForAlbum(_ album: Album) -> Data? {
        
        guard let imageInfo = album.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }),
            let thumbnailImage = LastFMService.shared.cachedImageForURL(imageInfo.url) else { return nil }
        return thumbnailImage.jpegData(compressionQuality: 1.0)
    }
}



