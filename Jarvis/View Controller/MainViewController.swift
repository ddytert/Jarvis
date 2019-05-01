//
//  MainViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let AlbumCellIdentifier = "AlbumCell"

final class MainViewController: UICollectionViewController {
    
    // MARK: - Properties
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 15.0,
                                             bottom: 20.0,
                                             right: 15.0)
    private let itemsPerRow: CGFloat = 3.0
    private var cellAspectRatio: CGFloat = 174.0 / 150.0    // Values taken from storyboard
    
    private var userAlbums: [UserAlbum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Receive notifications from UserAlbumStore about successful
        // saved albumm So it can uppdate the collection view
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(onDidSaveUserAlbum),
                       name: .didSaveUserAlbum,
                       object: nil)
        
        // Populate UserAlbum array
        if let albums = UserAlbumStore.shared.getUserAlbums() {
            userAlbums = albums
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowAlbumDetails",
            let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell),
            let albumDetailsVC = segue.destination as? AlbumDetailsViewController,
            let title = userAlbums[indexPath.row].title,
            let artist = userAlbums[indexPath.row].artist else { return }
        
        albumDetailsVC.selectedAlbumTitle = title
        albumDetailsVC.selectedArtistName = artist
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return userAlbums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCellIdentifier,
                                                      for: indexPath) as! AlbumCell
        let album = userAlbums[indexPath.row]
        cell.nameLabel.text = album.title
        
        // Get thumbnail image from thumbnail data stored in UserAlbum object
        if let data = album.thumbnail,
            let image = UIImage(data: data) {
            cell.imageView.image = image
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController {
    
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
    
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView,
                                  shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
    
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView,
                                  shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView,
                                  canPerformAction action: Selector,
                                  forItemAt indexPath: IndexPath,
                                  withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView,
                                  performAction action: Selector,
                                  forItemAt indexPath: IndexPath,
                                  withSender sender: Any?) {
     
     }
}

// MARK: - Collection View Flow Layout Delegate
extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * cellAspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - Notification handling
extension MainViewController {
    
    @objc func onDidSaveUserAlbum(_ notification: Notification) {
        if let albums = UserAlbumStore.shared.getUserAlbums() {
            userAlbums = albums
            collectionView.reloadData()
        }
    }
}
