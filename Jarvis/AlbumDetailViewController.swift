//
//  AlbumDetailViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 21.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

final class AlbumDetailViewController: UIViewController {
    
    // MARK: - Properties
    public var selectedAlbum: TestAlbum?

    // MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var tracklistLabel: UILabel!
    @IBOutlet weak var tracklistHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate UI
        if let album = selectedAlbum {
            imageView.image = album.image
            albumTitleLabel.text = album.name
            artistNameLabel.text = album.artist
            releaseYearLabel.text = String(album.year)
            // Set content of tracklist label
            fillTracklistLabel(album.tracks)
        }
        // Put content view into scroll view
        scrollView.addSubview(contentView)
    }
    
    override func viewDidLayoutSubviews() {
        
        let newContentSize = CGSize(width: scrollView.frame.size.width,
                                    height: contentView.frame.size.height)
        contentView.frame.size = newContentSize
        scrollView.contentSize = newContentSize
        
        // TODO: Set height of content view
        
//        var contentRect = CGRect.zero
//        for view in contentView.subviews {
//            contentRect = contentRect.union(view.frame)
//        }
//        scrollView.contentSize = contentRect.size
    }
    
    private func fillTracklistLabel(_ tracks: [TestTrack]) {
        var stringValue = String()
        var count = 0
        // Build multiline string
        for track in tracks {
            count = count + 1
            stringValue = stringValue + "\(count). \(track.name) (\(track.length))\n"
        }
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: style,
                                range: NSRange(location: 0, length: stringValue.count))
        tracklistLabel.attributedText = attrString
        tracklistLabel.numberOfLines = tracks.count
        // Set height of tracklist label
        let labelSize = attrString.size()
        tracklistHeightConstraint.constant = ceil(labelSize.height)
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
