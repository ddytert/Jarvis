//
//  AlbumDetailsViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 28.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

final class AlbumDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var tracklistLabel: UILabel!
    @IBOutlet weak var tracklistHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveAlbumButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    public var selectedAlbumTitle: String = ""  // TODO: Get rid of these
    public var selectedArtistName: String = ""
    
    public var selectedRelease: Release?
    
    private var selectedAlbum: Album?
    
    private var dateComponentFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        return formatter
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        // Put content view into scroll view
        scrollView.addSubview(contentView)
        // Set album, artist and year text label
        guard let release = selectedRelease else { return }
        
        albumTitleLabel.text = release.title
        artistNameLabel.text = release.artist
        
        if let year = selectedRelease?.year {
            releaseYearLabel.text = String(year)
        }
        
        // If album is already stored deactivate save album button
        let isStored = UserAlbumStore.shared.isAlbumStored(title: selectedAlbumTitle,
                                                           artist: selectedArtistName)
        if isStored {
            saveAlbumButton.isEnabled = false
        }
        // Get additional infos for selected album
        loadAlbumDetails()
    }
    
    private func loadAlbumDetails() {
        DiscogsService.shared.fetchDetailsForAlbum(selectedAlbumTitle, selectedArtistName) { [weak self] album, message in
            
            guard let self = self,
                let album = album  else { return }
            self.selectedAlbum = album
            self.fillTracklistLabel()
            self.loadBigAlbumImage()
        }
    }
    
    private func loadBigAlbumImage() {
        guard let album = selectedAlbum else { return }
        // Asynchronous loading of big album image
        guard let imageInfo = album.imageInfos.first(where: { $0.size == "extralarge" && !$0.url.isEmpty }) else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DiscogsService.shared.imageForURL(imageInfo.url) { [weak self] image in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            guard let albumImage = image else { return }
            
            self.albumImageView.image = albumImage
        }
    }
    
    private func fillTracklistLabel() {
        guard let album = selectedAlbum else { return }
        
        guard !album.tracks.tracks.isEmpty else {
            tracklistLabel.text = "No tracks found"
            return
        }
        let tracks = album.tracks.tracks
        var stringValue = String()
        var count = 0
        // Build multiline string
        for track in tracks {
            count = count + 1
            // Check, if track name is too long, otherwise truncate it
            var trackName = track.name
            // Calculate max number of characters
            let maxChars = Int(contentView.frame.width / 14)
            if trackName.count > maxChars {
                trackName = String(trackName.prefix(maxChars) + "...")
            }
            // Get formatted string from track duration
            var duration = track.duration
            if let time = TimeInterval(duration),
                let formatted = dateComponentFormatter.string(from: time) {
                duration = formatted
            }
            stringValue = stringValue + "\(count). \(trackName) (\(duration))\n"
        }
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineSpacing = 6
        style.lineHeightMultiple = 1.0
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: style,
                                range: NSRange(location: 0, length: stringValue.count))
        tracklistLabel.attributedText = attrString
        tracklistLabel.numberOfLines = tracks.count
        // Set height of tracklist label
        let labelSize = attrString.size()
        tracklistHeightConstraint.constant = ceil(labelSize.height * 1.2) // arbitrary scale factor
        // Force 'viewDidLayoutSubviews' to be called
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        
        // Adjust height of content view to varying height of tracklist
        var contentRect = CGRect.zero
        for view in contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        let newContentSize = CGSize(width: scrollView.frame.size.width,
                                    height: contentRect.height)
        contentView.frame.size = newContentSize
        scrollView.contentSize = newContentSize
    }
    
    // MARK: - IBActions
    @IBAction func saveAlbum(_ sender: UIBarButtonItem) {
        
        guard let selectedAlbum = selectedAlbum else { return }
        
        UserAlbumStore.shared.saveAlbum(selectedAlbum) { [weak self] success, message in
            
            guard let self = self else { return }
            
            let alertTitle = success ? "Album saved" : "Couldn't save album"
            // Show success or failure message
            let alert = UIAlertController(title: alertTitle,
                                          message: message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            // Deactivate save album button in case of successful saving
            self.saveAlbumButton.isEnabled = !success
        }
    }
}
