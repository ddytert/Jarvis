//
//  AlbumCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate: class {
    func deleteCell(_ cell: AlbumCell)
}

final class AlbumCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate:AlbumCellDelegate?
    
    public var userAlbum:UserAlbum? {
        didSet {
            guard let userAlbum = userAlbum else { return }
            nameLabel.text = userAlbum.title
            // Get thumbnail image from thumbnail data stored in UserAlbum object
            if let data = userAlbum.thumbnail,
                let image = UIImage(data: data) {
                imageView.image = image
            }
            deleteButton.isHidden = !isEditing
        }
    }
    public var isEditing:Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteCell(self)
    }
    
}
