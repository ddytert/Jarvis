//
//  ArtistDetailViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

private let AlbumCellIdentifier = "SmallAlbumCell"

final class ArtistDetailViewController: UIViewController {
    
    // MARK: - Properties
    public var selectedArtist: Artist?
    public var topAlbums: [JarvisAlbum] = []
    
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
    
    func populateUI() {
        guard let artist = selectedArtist else { return }
        artistNameLabel.text = artist.name
        
        // Get big artist image
        guard let image = artist.images.first(where: { $0.size == "extralarge" && !$0.imageURL.isEmpty }) else { return }
        LastFMService.shared.imageForURL(image.imageURL) { [weak self] image in
            guard let self = self,
                let artistImage = image else { return }
            self.artistImageView.image = artistImage
        }
        
        // Load top albums of artist
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Table view data source
extension ArtistDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCellIdentifier,
                                                 for: indexPath) as! SmallAlbumCell
        let album = topAlbums[indexPath.row]
        cell.album = album
        // Alternating background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 33.0/255.0, alpha: 1.0) : UIColor(white: 40.0/255.0, alpha: 1.0)
        // Set color of selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 54.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

// MARK: - Table view delegate
extension ArtistDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let artist = selectedArtist else { return }
        let album = topAlbums[indexPath.row]
        LastFMService.shared.fetchDetailsForAlbum(album.title, artist.name) { album, message in
            print(message)
            if let album = album {
                print(album.title)
                var count = 0
                for track in album.tracks.tracks {
                    count = count + 1
                    print("\(count). \(track.name) (\(track.duration))")
                }
            }

        }
    }
}
