//
//  ArtistDetailViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let AlbumCellIdentifier = "SmallAlbumCell"

final class ArtistDetailsViewController: UIViewController {
    
    // MARK: - Properties
    public var selectedArtist: Artist?
    public var topAlbums: [TopAlbum] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberAlbumsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide separator line
        tableView.separatorStyle = .none
        
        activityIndicator.isHidden = true

        populateUI()
    }
    
    private func populateUI() {
        guard let artist = selectedArtist else { return }
        artistNameLabel.text = artist.name
        
        // Asynchronous loading of big artist image
        guard let imageInfo = artist.imageInfos.first(where: { $0.size == "extralarge" && !$0.url.isEmpty }) else { return }
        LastFMService.shared.imageForURL(imageInfo.url) { [weak self] image in
            guard let self = self,
                let artistImage = image else { return }
            self.artistImageView.image = artistImage
        }
        
        // Asynchronous loading of top albums of artist
        numberAlbumsLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        LastFMService.shared.fetchTopAlbumsOfArtist(artist.name) { [weak self] albums, message in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.numberAlbumsLabel.isHidden = false
            self.numberAlbumsLabel.text = message

            guard let albums = albums else { return }
            self.topAlbums = albums
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAlbumDetails",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        if let albumDetailsVC = segue.destination as? AlbumDetailsViewController {
            albumDetailsVC.selectedAlbumTitle = topAlbums[indexPath.row].title
            albumDetailsVC.selectedArtistName = selectedArtist!.name
        }
    }
    
}

// MARK: - Table view data source
extension ArtistDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCellIdentifier,
                                                 for: indexPath) as! AlbumTableViewCell
        let album = topAlbums[indexPath.row]
        // Set VC as a delegate of the cell
        cell.delegate = self
        // Let the cell itself do the setup
        cell.album = album
        // Alternating background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 24.0/255.0, alpha: 1.0) : UIColor(white: 32.0/255.0, alpha: 1.0)
        // Set color of selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 54.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

extension ArtistDetailsViewController: AlbumTableViewCellDelegate {
    
    // Asynchronous loading of album image
    func requestImageForAlbumTableViewCell(_ cell: AlbumTableViewCell) {
        // Get url to thumbnail image
        guard let album = cell.album,
            let imageInfo = album.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(imageInfo.url) { image in
            
            if let albumImage = image {
                cell.albumImageView.image = albumImage
            }
        }
    }
}
