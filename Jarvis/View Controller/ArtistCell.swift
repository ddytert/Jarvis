//
//  ArtistCell.swift
//  Jarvis
//
//  Created by Daniel Dytert on 25.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

protocol ArtistCellDelegate: class {
    func requestImageForArtistCell(_ cell: ArtistCell)
}

final class ArtistCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    
    // MARK: - Properties
    weak var delegate: ArtistCellDelegate?
    
    // Moved TableViewCell setup logic from VC to cell itself
    public var artist: Artist? {
        didSet {
            guard let artist = artist else { return }
            artistNameLabel.text = artist.name
            // Set image to default image first
            artistImageView.image = UIImage(named: "IconUnknownArtist.png")
            // Let the view controller communicate with the model
            delegate?.requestImageForArtistCell(self)
        }
    }
}
