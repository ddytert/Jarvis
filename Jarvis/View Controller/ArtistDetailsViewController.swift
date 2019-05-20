//
//  ArtistDetailViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let ReleaseCellIdentifier = "ReleaseTableViewCell"

final class ArtistDetailsViewController: UIViewController {
    
    // MARK: - Properties
    public var selectedArtist: Artist?
    public var topReleases: [Release] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberReleasessLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Receive notifications from UserReleasesStore about successful
        // saved release So it can update the table view (show the blue saved release mark)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(onDidSaveUserRelease),
                       name: .didSaveUserRelease,
                       object: nil)
        
        // Hide separator line
        tableView.separatorStyle = .none
        
        activityIndicator.isHidden = true
        
        populateUI()
    }
    
    private func populateUI() {
        guard let artist = selectedArtist else { return }
        artistNameLabel.text = artist.name
                
        // If available load big artist image asynchronously
        if !artist.imageURL.isEmpty {
            print("Big artist image found")
            DiscogsService.shared.imageForURL(artist.imageURL) { [weak self] image in
                guard let self = self,
                    let artistImage = image else { return }
                self.artistImageView.image = artistImage
            }
            // Otherwise load thumbnail image
        } else if !artist.thumbURL.isEmpty {
            print("Thumbnail artist image found")
            DiscogsService.shared.imageForURL(artist.thumbURL) { [weak self] image in
                guard let self = self,
                    let artistImage = image else { return }
                self.artistImageView.image = artistImage
            }
        } else {
            print("No artist image found")

        }
        // Asynchronous loading of top releases of artist
        numberReleasessLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DiscogsService.shared.fetchReleasesOfArtist(artist.id) { [weak self] releases, message in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.numberReleasessLabel.isHidden = false
            self.numberReleasessLabel.text = message
            
            guard let releases = releases else { return }
            self.topReleases = releases
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowReleaseDetails",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        if let releaseDetailsVC = segue.destination as? ReleaseDetailsViewController {
            let release = topReleases[indexPath.row]
            releaseDetailsVC.selectedRelease = release
            if let thumbURL = release.thumbURL {
                let image = DiscogsService.shared.getCachedImageForURL(thumbURL)
                releaseDetailsVC.releaseImageView.image = image
            }
        }
    }
    
}

// MARK: - Table view data source
extension ArtistDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topReleases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReleaseCellIdentifier,
                                                 for: indexPath) as! ReleaseTableViewCell
        let release = topReleases[indexPath.row]
        // Set VC as a delegate of the cell
        cell.delegate = self
        // Let the cell itself do the setup
        cell.release = release
        // Alternating background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 24.0/255.0, alpha: 1.0) : UIColor(white: 32.0/255.0, alpha: 1.0)
        // Set color of selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 54.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

extension ArtistDetailsViewController: ReleaseTableViewCellDelegate {
    
    // Asynchronous loading of release image
    func requestImageForReleaseTableViewCell(_ cell: ReleaseTableViewCell) {
        // Get url to thumbnail image
        guard let release = cell.release,
            let thumbURL = release.thumbURL,
            !thumbURL.isEmpty else { return }
        
        DiscogsService.shared.imageForURL(thumbURL) { image in
            
            if let releaseImage = image {
                cell.releaseImageView.image = releaseImage
            }
        }
    }
    
    func checkIfReleaseIsAlreadySaved(_ cell: ReleaseTableViewCell) {
        
        guard let release = cell.release else { return }
        
        let isStored = UserReleaseStore.shared.isReleaseStored(releaseId: release.id)
        let imageName = isStored ? "IconReleaseStoredBlue.png" : "IconReleaseStoredBlank.png"
        cell.savedMarkImageView.image = UIImage(named: imageName)
    }
}

// MARK: - Notification handling
extension ArtistDetailsViewController {
    
    @objc func onDidSaveUserRelease(_ notification: Notification) {
        tableView.reloadData()
    }
}
