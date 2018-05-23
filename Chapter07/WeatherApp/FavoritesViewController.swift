//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/25/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import Foundation
import UIKit

public class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    public var receivedData:Int?
    
    var favorites:[Location] = []
    
    public var selectedItem:Location?
    
    let formatter = DateFormatter()
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        formatter.dateFormat = "H:mm"
        
        loadFavorites()
        
        if favorites.count == 0 {
            //New York is a default location
            var loc = Location.init(city: City.NewYork)
            // or -4 * 3600 if in DST
            loc.timeZone = -5 * 3600
            favorites.append(loc)
        }
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
    }
    
//    public override func viewDidDisappear(_ animated: Bool) {
//        
//        saveFavorites(favorites: favorites)
//    }
    
   

    

    
    // MARK: save favorites
    
    func saveFavorites(favorites:[Location]) {
        //TODO: ... do the actual saving
        
        let encoded = try? JSONEncoder().encode(favorites)
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentsDirectoryPathString + "/favorites.json"
        
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: encoded, attributes: nil)
        } else {
            if let file = FileHandle(forWritingAtPath:filePath) {
                file.write(encoded!)
            }
        }
    }
    
    func loadFavorites() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentsDirectoryPathString + "/favorites.json"
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let file = FileHandle(forReadingAtPath:filePath) {
                let data = file.readDataToEndOfFile()
                
                let favs = try? JSONDecoder().decode([Location].self, from: data)
                favorites = favs!
            }
        }
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    // MARK: UITableViewDataSource functions
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //1 for the last cell
        return favorites.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        if index < favorites.count {
            
            let location = favorites[index]
            
            let cell:FavoriteViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! FavoriteViewCell
            
            cell.city.text = location.name
            cell.temperature.text =  location.temperature + LocationForecast.degreeSymbol
            
            let date = Date()

            formatter.timeZone = TimeZone(secondsFromGMT: location.timeZone)
            print("NY date: \(formatter.string(from: date))")
            cell.time.text = formatter.string(from: date)
            
            return cell
            
        }
        //last cell is a static one
        let cell:StaticViewCell = tableView.dequeueReusableCell(withIdentifier: "AddLocationCell", for: indexPath) as! StaticViewCell
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    // MARK: UITableViewDelegate
    //handle touch
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == favorites.count {
            //TODO: open a new view controller
        } else {
            selectedItem = favorites[indexPath.row]
            //TODO: pick this location and save all locations
            print("Location: \(favorites[indexPath.row].name)")
            saveFavorites(favorites: favorites)
        }
    }
}
