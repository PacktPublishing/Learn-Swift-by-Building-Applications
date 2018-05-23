//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/4/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {

    @IBAction func onFavoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: "showFavorites", sender: sender)
    }
    
    var model:LocationForecast?
    //details outlet
    @IBOutlet weak var details: UICollectionView!
    
    @IBOutlet weak var nextDays: UITableView!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var cityWeather: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    var forecast:[Forecast] = []
    
    var degreeSymbol = "°"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //fill the model with mock data
        model = LocationForecast.getTestData()
        //out class impelemnts the correct protocols
        details.dataSource = self
        nextDays.dataSource = self
        //handle the case if the location has no name
        city.text = model?.location?.name ?? "???"
        cityWeather.text = model?.weather ?? "???"
        temperature.text = getCurrentTemperature()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper function
    
    func getCurrentTemperature() -> String {
        var lastTemperature = "?"
        if let forecastList = model?.forecastForToday {
            let currentDate = Date()
            
            for forecast in forecastList {
                if forecast.date < currentDate {
                    lastTemperature = "\(forecast.temperature)"
                }
            }
        }
        
        return lastTemperature
    }
    
    // MARK: UICollectionViewDataSource protocol
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.forecastForToday?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:WeatherViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherViewCell
        
        let forecast:Forecast = (model?.forecastForToday?[indexPath.row])!
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        cell.time.text = formatter.string(from: forecast.date)
        cell.icon.image =  getIcon(weather: forecast.weather)
        cell.temperature.text = "\(forecast.temperature)\(self.degreeSymbol)"
        
        return cell
        
    }
    
    // MARK: UITableViewCollectionDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.forecastForNextDays?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DailyForecastViewCell = tableView.dequeueReusableCell(withIdentifier: "FullDayWeatherCell", for: indexPath) as! DailyForecastViewCell
        
        let forecast:DailyForecast = (model?.forecastForNextDays?[indexPath.row])!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        cell.day.text = formatter.string(from: forecast.date)
        
        cell.icon.image =  getIcon(weather: forecast.weather)
        
        cell.temperature.text = "\(forecast.maxTemp)\(self.degreeSymbol)/\(forecast.minTemp)\(self.degreeSymbol)"
        
        return cell
    }
    
    // MARK: private
    
    private func getIcon(weather:String) -> UIImage? {
        return LocationForecast.getImageFor(weather:weather)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "showFavorites":
                var favVC: FavoritesViewController = segue.destination as! FavoritesViewController
                favVC.receivedData = 42
                print("transfer the date");
            default:
                break;
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(sender: UIStoryboardSegue) {
        if let favoritesVC = sender.source as? FavoritesViewController {
            model = LocationForecast()
            model?.location = favoritesVC.selectedItem
        }
    }

}

