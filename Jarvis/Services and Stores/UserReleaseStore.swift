//
//  UserReleaseStore.swift
//  Jarvis
//
//  Created by Daniel Dytert on 29.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

// Class responsible for persistent storage of user releases and images of releases

import UIKit
import CoreData


final class UserReleaseStore {
    
    // MARK: - Properties
    // Return singleton instance
    public static let shared = UserReleaseStore()
    
    private var managedContext:NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    // Initialization
    private init() {
    }
    
    public func saveRelease(_ release: Release,
                          completion: (Bool, String) -> Void) {
        
        guard let managedContext = managedContext else {
            completion(false, "Missing data store")
            return
        }
        if isReleaseStored(releaseId: release.id) {
            completion(false, "Release already saved")
            return
        }        
        let entity = NSEntityDescription.entity(forEntityName: "UserRelease",
                                                in: managedContext)!
        let userRelease = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        userRelease.setValue(release.title, forKeyPath: "title")
        userRelease.setValue(release.year, forKeyPath: "year")
        userRelease.setValue(release.type, forKeyPath: "type")
        userRelease.setValue(release.artists?.first?.name, forKeyPath: "artist")
        userRelease.setValue(release.id, forKeyPath: "id")
        userRelease.setValue(release.images?.first?.uri, forKeyPath: "imageURL")
        let imageData = getImageDataForRelease(release)
        userRelease.setValue(imageData, forKeyPath: "imageData")
        
        do {
            try managedContext.save()
            // Inform other objects about successful saving of release
            // (View controller which then updates their collection/table views)
            let nc = NotificationCenter.default
            nc.post(name: .didSaveUserRelease, object: nil)
            
            completion(true, "")
            
        } catch let error as NSError {
            completion(false, "\(error), \(error.userInfo)")
            return
        }
    }
    
    public func deleteRelease(_ release: UserRelease) -> Bool {
        
        guard let managedContext = managedContext else {
            return false
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRelease")
        fetchRequest.predicate = NSPredicate(format: "id = %i", release.id)
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
    
    public func getUserReleases() -> [UserRelease]? {
        
        guard let managedContext = managedContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserRelease")
        
        do {
            let userReleases = try managedContext.fetch(fetchRequest)
            return userReleases as? [UserRelease]
            
        } catch {
            return nil
        }
    }
    
    public func isReleaseStored(releaseId: Int) -> Bool {
        
        guard let managedContext = managedContext else { return false }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRelease")
        fetchRequest.predicate = NSPredicate(format: "id = %i", releaseId)
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
    
    private func getImageDataForRelease(_ release: Release) -> Data? {
        
        guard let imageURL = release.images?.first?.uri,
            let image = DiscogsService.shared.getCachedImageForURL(imageURL) else { return nil }
        return image.jpegData(compressionQuality: 1.0)
    }
}



