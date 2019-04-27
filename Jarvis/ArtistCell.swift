//
//  ArtistCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 25.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

final class ArtistCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    
    // MARK: - Properties
    public var artist:Artist? {
        didSet {
            guard let artist = artist else { return }
            artistNameLabel.text = artist.name
            // Set image to default image first
            artistImageView.image = UIImage(named: "IconUnknownArtist.png")
            requestImageForArtist(artist)
        }
    }
    
    private func requestImageForArtist(_ artist: Artist) {
        // Get url to thumbnail image
        guard let image = artist.images.first(where: { $0.size == "large" && !$0.imageURL.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(image.imageURL) { [weak self] image in
            guard let self = self,
                let artistImage = image else { return }
            self.artistImageView.image = artistImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
