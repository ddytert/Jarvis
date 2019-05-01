//
//  MainViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let AlbumCellIdentifier = "AlbumCell"

final class UserAlbumsViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
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
        
        navigationItem.leftBarButtonItem = editButtonItem
        
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
        // End editing mode
        isEditing = false
    }
}

// MARK: UICollectionViewDataSource
extension UserAlbumsViewController {
    
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
        cell.userAlbum = album
        cell.isEditing = self.isEditing
        cell.delegate = self
        
        
        return cell
    }
}

// MARK: Editing
extension UserAlbumsViewController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        // Hide search bar button item
        searchBarButtonItem.isEnabled = !editing
        // Refresh collection view
        collectionView?.reloadData()
    }
}

// MARK: - Collection View Flow Layout Delegate
extension UserAlbumsViewController : UICollectionViewDelegateFlowLayout {
    
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

// MARK: - AlbumCell delegate methods
extension UserAlbumsViewController: AlbumCellDelegate {
    
    func deleteCell(_ cell: AlbumCell) {
        // Try to delete User album from Core Data store and in case it succeeded update collection viwew
        if let indexPath = collectionView?.indexPath(for: cell) {
            
            let success = UserAlbumStore.shared.deleteAlbum(userAlbums[indexPath.row])
            if success {
                // Updata user albums array
                if let albums = UserAlbumStore.shared.getUserAlbums() {
                    userAlbums = albums
                    self.collectionView?.deleteItems(at: [indexPath])
                }
            } else {
                // Show failure message to user
                let alert = UIAlertController(title: "Couldn't delete album",
                                              message: "",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: - Notification handling
extension UserAlbumsViewController {
    
    @objc func onDidSaveUserAlbum(_ notification: Notification) {
        if let albums = UserAlbumStore.shared.getUserAlbums() {
            userAlbums = albums
            collectionView.reloadData()
        }
    }
}
