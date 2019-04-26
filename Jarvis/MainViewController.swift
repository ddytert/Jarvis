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

    private var albums: [Album] = AlbumStore.generateAlbumsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAlbumDetails",
            let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else {
                return
        }
        if let albumDetailVC = segue.destination as? AlbumDetailViewController {
            albumDetailVC.selectedAlbum = albums[indexPath.row]
        }
     }
}

// MARK: UICollectionViewDataSource
extension MainViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCellIdentifier,
                                                      for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.imageView.image = album.image
        cell.nameLabel.text = album.name
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MainViewController {
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
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
