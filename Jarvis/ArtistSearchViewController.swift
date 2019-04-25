//
//  ArtistSearchViewController.swift
//  Jarvis
//
//  Created by Daniel Dytert on 24.04.19.
//  Copyright © 2019 DanLo Interactive. All rights reserved.
//

import UIKit
import Alamofire

let lastfmAuthKey = "1f5c01f4a1139c3ccc96eaab9042a83d"

class ArtistSearchViewController: UITableViewController {
    
    // MARK: - Properties
    var foundArtists:[Artist] = []
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Table view data source
extension ArtistSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundArtists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Search bar delegate

extension ArtistSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let artistName = searchBar.text else { return }
        
        searchBar.resignFirstResponder()
        searchForArtist(artistName) { artists in
            
            if let artists = artists {
                print("\(artists.count) artist found")
                artists.forEach() {
                    print("Name: \($0.name)")
                    print("Images: ")
                    $0.images.forEach() {
                        print($0)
                    }
                }
            }
        }
    }
}

// MARK: Download data
extension ArtistSearchViewController {
    
    func searchForArtist(_ artistName: String, completion: @escaping ([Artist]?) -> Void) {
                
        Alamofire.request("http://ws.audioscrobbler.com/2.0/",
                          parameters: ["method": "artist.search",
                                       "artist": artistName,
                                       "api_key": lastfmAuthKey,
                                       "format": "json"])
            .responseData { response in
                guard response.result.isSuccess,
                    let data = response.data else {
                        print("Error while fetching artists: \(String(describing: response.result.error))")
                        completion(nil)
                        return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ArtistSearchResults.self, from: data)
                    let artists = searchResult.results.artistMatches.artists
                    completion(artists)
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
}
