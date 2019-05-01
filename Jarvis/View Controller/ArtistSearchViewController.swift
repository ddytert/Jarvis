//
//  ArtistSearchViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit
import Alamofire

private let ArtistCellIdentifier = "ArtistCell"

final class ArtistSearchViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchInfoLabel: UILabel!
    
    // MARK: - Properties
    public var foundArtists:[Artist] = []
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide separator line
        tableView.separatorStyle = .none
        
        activityIndicator.isHidden = true
        searchInfoLabel.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowArtistDetails",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        if let artistDetailVC = segue.destination as? ArtistDetailsViewController {
            artistDetailVC.selectedArtist = foundArtists[indexPath.row]
        }
    }
}

// MARK: - Table view data source
extension ArtistSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCellIdentifier,
                                                 for: indexPath) as! ArtistCell
        let artist = foundArtists[indexPath.row]
        // Set VC as a delegate of the cell
        cell.delegate = self
        // Let the cell itself do the setup
        cell.artist = artist
        // Alternating background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 24.0/255.0, alpha: 1.0) : UIColor(white: 32.0/255.0, alpha: 1.0)
        // Set color of selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 54.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

// MARK: - Search bar delegate
extension ArtistSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let artistName = searchBar.text else { return }
        
        searchBar.resignFirstResponder()
        searchInfoLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        // Clear table view
        foundArtists.removeAll()
        tableView.reloadData()
        
        LastFMService.shared.searchForArtist(artistName) { [weak self] artists, message in
            
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.searchInfoLabel.isHidden = false
            self.searchInfoLabel.text = message
            
            guard let artists = artists else { return }
            
            self.foundArtists = artists
            self.tableView.reloadData()
        }
    }
}

// MARK: - ArtistCell delegate methods
extension ArtistSearchViewController: ArtistCellDelegate {
    
    // Asynchronous loading of artist image
    func requestImageForArtistCell(_ cell: ArtistCell) {
        // Get url to thumbnail image
        guard let artist = cell.artist,
            let imageInfo = artist.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(imageInfo.url) { image in
            if let artistImage = image {
                cell.artistImageView.image = artistImage
            }
        }
    }
}

