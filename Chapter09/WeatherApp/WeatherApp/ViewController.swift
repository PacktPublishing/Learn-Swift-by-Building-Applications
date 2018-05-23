//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/4/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {

    @IBAction func onFavoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: "showFavorites", sender: sender)
    }
    
    @IBAction func onAboutClicked(_ sender: Any) {
        performSegue(withIdentifier: "showAbout", sender: sender)
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
        
        //fill the model with mock data
//        model = LocationForecast.getTestData()
        //out class impelemnts the correct protocols
        details.dataSource = self
        nextDays.dataSource = self
        //handle the case if the location has no name
        city.text = model?.location?.name ?? "???"
        cityWeather.text = model?.weather ?? "???"
        temperature.text = getCurrentTemperature()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentCity = City.NewYork
        ForecastStore.instance.loadForecastAlamofire(for: currentCity) { [weak self](response, error)  in
            if let error = error {
                print("there is an error")
                switch error {
                case .invalidCity:
                    let alert = UIAlertController(title: "Network problem", message: "We've faced a problem while tying to load the forecast data. Please, try later.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    // toast with a specific duration and position
//                    self?.view.makeToast("We've faced a problem while trying to load the forecast data. Please, try later.", duration: 1.5, position: .top)
                case .noConnection:
                    //handle this case
                    break
                case .invalidURL:
                    //handle this case
                    break
                case .wrongResponse:
                    //handle this case
                    break
                }
            } else if let responseModel = response {
                print("Everything is fine.")
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI(city: currentCity, forecast:responseModel)
                }
            }
        }
    }
    
    func updateUI(city aCity:City, forecast:WeatherResponse) {
        city.text = aCity.name
        if forecast.weather.count > 0 {
            cityWeather.text = forecast.weather[0].description ?? "???"
        }
        temperature.text = String(format: "%.0f", forecast.forecast.temperature)
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

