//
//  ArtistSearchViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit
import Alamofire

private let ArtistCellIdentifier = "ArtistCell"

final class ArtistSearchViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchInfoLabel: UILabel!
    
    // MARK: - Properties
    public var foundArtists:[Artist] = []
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide separator line
        tableView.separatorStyle = .none
        
        activityIndicator.isHidden = true
        searchInfoLabel.isHidden = false
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowArtistDetails",
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {
                return
        }
        if let artistDetailVC = segue.destination as? ArtistDetailViewController {
            artistDetailVC.selectedArtist = foundArtists[indexPath.row]
        }
    }
}

// MARK: - Table view data source
extension ArtistSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCellIdentifier,
                                                 for: indexPath) as! ArtistCell
        let artist = foundArtists[indexPath.row]
        cell.artist = artist
         // Alternating background colors
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 33.0/255.0, alpha: 1.0) : UIColor(white: 40.0/255.0, alpha: 1.0)
        // Set color of selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.0, green: 54.0/255.0, blue: 111.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
        
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}

// MARK: - Search bar delegate

extension ArtistSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let artistName = searchBar.text else { return }
        
        searchBar.resignFirstResponder()
        searchInfoLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        foundArtists.removeAll()
        tableView.reloadData()
        
        LastFMService.shared.searchForArtist(artistName) { [weak self] artists, message in
            
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.searchInfoLabel.isHidden = false
            self.searchInfoLabel.text = message
            
            guard let artists = artists else { return }
            
            self.foundArtists = artists
            self.tableView.reloadData()
//            if artists.count > 0 {
//                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
//                                           at: .top,
//                                           animated: true)
//            }
        }
    }
}

