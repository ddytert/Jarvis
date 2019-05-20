//
//  UserReleasesViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let ReleaseCellIdentifier = "ReleaseCell"

final class UserReleasesViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    private var userReleases: [UserRelease] = []

    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 15.0,
                                             bottom: 20.0,
                                             right: 15.0)
    private let itemsPerRow: CGFloat = 3.0
    private var cellAspectRatio: CGFloat = 174.0 / 150.0    // Values taken from storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        // Receive notifications from UserReleaseStore about successful
        // saved release so it can uppdate the collection view
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(onDidSaveUserRelease),
                       name: .didSaveUserRelease,
                       object: nil)
        
        // Populate UserReleases array
        if let releases = UserReleaseStore.shared.getUserReleases() {
            userReleases = releases
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowReleaseDetails",
            let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell),
            let releaseDetailsVC = segue.destination as? ReleaseDetailsViewController else { return }
        let userRelease = userReleases[indexPath.row]
        let selectedRelease = Release(title: userRelease.title!,
                                      id: Int(userRelease.id),
                                      type: userRelease.type,
                                      artist: userRelease.artist,
                                      artists: nil,
                                      year: Int(userRelease.year),
                                      thumbURL: nil,
                                      images: nil,
                                      tracklist: nil,
                                      genres: nil)
        releaseDetailsVC.selectedRelease = selectedRelease
        // Set release image if available
        if let imageData = userRelease.imageData {
            releaseDetailsVC.releaseImageView.image = UIImage(data: imageData)
        }
        // End editing mode
        isEditing = false
    }
}

// MARK: UICollectionViewDataSource
extension UserReleasesViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return userReleases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReleaseCellIdentifier,
                                                      for: indexPath) as! ReleaseCell
        let release = userReleases[indexPath.row]
        
        cell.delegate = self
        cell.isEditing = self.isEditing
        cell.userRelease = release
        
        return cell
    }
}

// MARK: Editing
extension UserReleasesViewController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        // Hide search bar button item
        searchBarButtonItem.isEnabled = !editing
        // Refresh collection view
        collectionView?.reloadData()
    }
}

// MARK: - Collection View Flow Layout Delegate
extension UserReleasesViewController : UICollectionViewDelegateFlowLayout {
    
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

// MARK: - ReleaseCell delegate methods
extension UserReleasesViewController: ReleaseCellDelegate {
    
    func deleteCell(_ cell: ReleaseCell) {
        // Try to delete User release from Core Data store and in case it succeeded update collection view
        if let indexPath = collectionView?.indexPath(for: cell) {
            
            let success = UserReleaseStore.shared.deleteRelease(userReleases[indexPath.row])
            if success {
                // Update user releases array
                if let releases = UserReleaseStore.shared.getUserReleases() {
                    userReleases = releases
                    self.collectionView?.deleteItems(at: [indexPath])
                }
            } else {
                // Show failure message to user
                let alert = UIAlertController(title: "Couldn't delete release",
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
extension UserReleasesViewController {
    
    @objc func onDidSaveUserRelease(_ notification: Notification) {
        if let releases = UserReleaseStore.shared.getUserReleases() {
            userReleases = releases
            collectionView.reloadData()
        }
    }
}
