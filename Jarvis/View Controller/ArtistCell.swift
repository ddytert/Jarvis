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
    
    // Moved TableViewCell setup logic from VC to cell itself
    public var artist:Artist? {
        didSet {
            guard let artist = artist else { return }
            artistNameLabel.text = artist.name
            // Set image to default image first
            artistImageView.image = UIImage(named: "IconUnknownArtist.png")
            requestImageForArtist(artist)
        }
    }
    // Asynchronous loading of artist image 
    private func requestImageForArtist(_ artist: Artist) {
        // Get url to thumbnail image
        guard let imageInfo = artist.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(imageInfo.url) { [weak self] image in
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
