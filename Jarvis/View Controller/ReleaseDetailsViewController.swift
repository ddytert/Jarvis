//
//  ReleaseDetailsViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 28.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit

final class ReleaseDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var releaseTitleLabel: UILabel!
    @IBOutlet weak var releaseImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var tracklistLabel: UILabel!
    @IBOutlet weak var tracklistHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveReleaseButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    public var selectedRelease: Release?
    
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
        // Set release, artist and year text label
        self.populateReleaseLabels()
        
        if let release = selectedRelease {
            // If release is already stored deactivate save release button
            let isStored = UserReleaseStore.shared.isReleaseStored(releaseId: release.id)
            if isStored {
                saveReleaseButton.isEnabled = false
            }
        }
        // Get additional infos for selected release
        loadReleaseDetails()
    }
    
    private func loadReleaseDetails() {
        
        guard let release = selectedRelease,
            let type = release.type else { return }
        
        DiscogsService.shared.fetchDetailsForRelease(release.id, type: type) { [weak self] release, message in
            guard let self = self,
                let release = release  else { return }
            self.selectedRelease = release
            
            self.populateReleaseLabels()
            self.fillTracklistLabel()
            self.loadBigReleaseImage()
        }
    }
    
    private func populateReleaseLabels() {
        guard let release = selectedRelease else { return }
        
        releaseTitleLabel.text = release.title
        if let artistName = release.artist {
            artistNameLabel.text = artistName
        } else if let artistName = release.artists?.first?.name {
            artistNameLabel.text = artistName
        }
        if let year = release.year {
            releaseYearLabel.text = String(year)
        }
    }
    
    private func loadBigReleaseImage() {
        guard let release = selectedRelease else { return }
        // Asynchronous loading of big release image
        guard let images = release.images,
            !images.isEmpty,
            let image = images.first else { return }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DiscogsService.shared.imageForURL(image.uri) { [weak self] image in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            guard let releaseImage = image else { return }
            
            self.releaseImageView.image = releaseImage
        }
    }
    
    private func fillTracklistLabel() {
        
        guard let release = selectedRelease,
            let tracklist = release.tracklist else { return }
        
        guard !tracklist.isEmpty else {
            tracklistLabel.text = "No tracks found"
            return
        }
        var stringValue = String()
        var count = 0
        // Build multiline string
        for track in tracklist {
            count = count + 1
            // Check, if track name is too long, otherwise truncate it
            var trackName = track.title
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
        tracklistLabel.numberOfLines = tracklist.count
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
    @IBAction func saveRelease(_ sender: UIBarButtonItem) {
        
        guard let selectedRelease = selectedRelease else { return }
        
        UserReleaseStore.shared.saveRelease(selectedRelease) { [weak self] success, message in
            
            guard let self = self else { return }
            
            let alertTitle = success ? "Release saved" : "Couldn't save release"
            // Show success or failure message
            let alert = UIAlertController(title: alertTitle,
                                          message: message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            // Deactivate save release button in case of successful saving
            self.saveReleaseButton.isEnabled = !success
        }
    }
}
