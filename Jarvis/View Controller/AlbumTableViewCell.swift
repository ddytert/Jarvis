//
//  AlbumTableViewCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

protocol AlbumTableViewCellDelegate: class {
    func requestImageForAlbumTableViewCell(_ cell: AlbumTableViewCell)
}

final class AlbumTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    // MARK: - Properties
    weak var delegate:AlbumTableViewCellDelegate?
    
    // Moved TableViewCell setup
    public var album:TopAlbum? {
        didSet {
            guard let album = album else { return }
            albumTitleLabel.text = album.title
            // Set album image to default image first
            albumImageView.image = UIImage(named: "IconUnknownAlbum.png")
            delegate?.requestImageForAlbumTableViewCell(self)
        }
    }
}
