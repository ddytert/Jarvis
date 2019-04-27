//
//  SmallAlbumCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

class SmallAlbumCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    // MARK: - Properties
    public var album:JarvisAlbum? {
        didSet {
            guard let album = album else { return }
            albumTitleLabel.text = album.title
            // Set album image to default image first
            albumImageView.image = UIImage(named: "IconUnknownAlbum.png")
            requestImageForAlbum(album)
        }
    }
    
    private func requestImageForAlbum(_ album: JarvisAlbum) {
        // Get url to thumbnail image
        guard let image = album.images.first(where: { $0.size == "large" && !$0.imageURL.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(image.imageURL) { [weak self] image in
            guard let self = self,
                let albumImage = image else { return }
            self.albumImageView.image = albumImage
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
