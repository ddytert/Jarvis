//
//  ReleaseTableViewCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 26.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

protocol ReleaseTableViewCellDelegate: class {
    func requestImageForReleaseTableViewCell(_ cell: ReleaseTableViewCell)
    func checkIfReleaseIsAlreadySaved(_ cell: ReleaseTableViewCell)
}

final class ReleaseTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var releaseTitleLabel: UILabel!
    @IBOutlet weak var releaseImageView: UIImageView!
    @IBOutlet weak var savedMarkImageView: UIImageView!
    
    // MARK: - Properties
    weak var delegate: ReleaseTableViewCellDelegate?
    
    // Moved TableViewCell setup
    public var release: Release? {
        didSet {
            guard let release = release else { return }
            releaseTitleLabel.text = release.title
            // Set release image to default image first
            releaseImageView.image = UIImage(named: "IconUnknownRelease.png")
            delegate?.checkIfReleaseIsAlreadySaved(self)
            delegate?.requestImageForReleaseTableViewCell(self)
        }
    }
}
