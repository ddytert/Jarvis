//
//  ReleaseCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

protocol ReleaseCellDelegate: class {
    func deleteCell(_ cell: ReleaseCell)
}

final class ReleaseCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: ReleaseCellDelegate?
    
    public var userRelease: UserRelease? {
        didSet {
            guard let userRelease = userRelease else { return }
            nameLabel.text = userRelease.title
            // Get thumbnail image from thumbnail data stored in UserRelease object
            if let data = userRelease.imageData,
                let image = UIImage(data: data) {
                imageView.image = image
            }
            deleteButton.isHidden = !isEditing
        }
    }
    public var isEditing: Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteCell(self)
    }
    
}
