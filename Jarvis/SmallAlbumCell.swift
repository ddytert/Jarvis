//
//  SmallAlbumCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

final class SmallAlbumCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    // MARK: - Properties
    
    // Moved TableViewCell setup logic from VC to cell itself
    public var album:JarvisAlbum? {
        didSet {
            guard let album = album else { return }
            albumTitleLabel.text = album.title
            // Set album image to default image first
            albumImageView.image = UIImage(named: "IconUnknownAlbum.png")
            requestImageForAlbum(album)
        }
    }
    
    // Asynchronous loading of album image
    private func requestImageForAlbum(_ album: JarvisAlbum) {
        // Get url to thumbnail image
        guard let imageInfo = album.imageInfos.first(where: { $0.size == "large" && !$0.url.isEmpty }) else { return }
        
        LastFMService.shared.imageForURL(imageInfo.url) { [weak self] image in
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
