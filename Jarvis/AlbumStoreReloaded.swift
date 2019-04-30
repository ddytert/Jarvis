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


final class AlbumStoreReloaded {
    
    // MARK: - Properties
    // Return singleton instance
    public static let shared = AlbumStoreReloaded()
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    // Initialization
    private init() {
    }
    
    public func saveAlbum(_ album: Album) {
        
    }
    
    public func saveImageToDocuments(image: UIImage, filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    public func loadImageFromDocuments(filename: String) -> UIImage? {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.absoluteString)
    }
  
}
