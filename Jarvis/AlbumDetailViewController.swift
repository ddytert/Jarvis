//
//  AlbumDetailViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    public var selectedAlbum: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let album = selectedAlbum {
            imageView.image = album.image
            albumTitleLabel.text = album.name
            artistNameLabel.text = album.artist
            releaseYearLabel.text = String(album.year)
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
