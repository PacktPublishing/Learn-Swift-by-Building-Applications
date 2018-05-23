//
//  ViewController.swift
//  CityPickerDemo
//
//  Created by Emil Atanasov on 7/31/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries:[Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = Country.getHardcodedData()
        //search

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: UITableDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries[section].cities.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countries[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let country = self.countries[indexPath.section]
        let city = country.cities[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = "Population: \(city.population)"
        
        return cell

    }
    
    // MARK: UITableDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let country = self.countries[indexPath.section]
        let city = country.cities[indexPath.row]
        
        print("City \(city.name) was selected.")
    }
    
    // MARK: UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!.localizedLowercase
        
        if searchText.count > 0 {
            var filteredCountries:[Country] = []
            for country in countries {
                if let filteredCountry = filteredCities(in: country, searchText: searchText) {
                    filteredCountries.append(filteredCountry)
                }
            }
            countries = filteredCountries
        } else {
            countries = Country.getHardcodedData()
        }
        tableView.reloadData()
    }
    
    //helper function for proper filtering
    func filteredCities(in country:Country, searchText:String) -> Country? {
        let c = Country(name: country.name)
        c.cities = country.cities.filter {
            $0.name.localizedLowercase.contains(searchText)
        }
        
        return c.cities.count > 0 ? c : nil
    }
}

