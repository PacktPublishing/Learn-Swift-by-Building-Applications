//
//  LocationForecast.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/14/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var midnight: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

//city & country model
class Country {
    var name = "No name"
    var cities:[City] = []
    
    init(name:String) {
        self.name = name
    }
    
    init(name:String, cities:[City]) {
        self.name = name
        self.cities = cities
    }
}

public class City: Codable {
    var name: String
    var id:Int?
    
    init(name:String) {
        self.name = name
    }
    
    static var NewYork: City = {
        
            let newYork = City(name: "New York")
//            newYork.id = 5128638
            return newYork
    }()
}

public class Location: Codable {
    var city:City
    
    init(city: City) {
        self.city = city
    }
    
    var name: String {
        get {
            return self.city.name
        }
    }
    
    var timeZone:Int = 0
    var temperature:String = "-"
}

struct WeatherResponse: Codable {
    var weather:[WeatherInfoVO]
    var visibility:Int
    var wind:WindVO
    var time:Int
    var name:String
    var id:Int
    var responseCode:Int
    var forecast:WeatherVO
    
    enum CodingKeys: String, CodingKey
    {
        case weather
        case visibility
        case wind
        case time = "dt"
        case name
        case id
        case responseCode = "cod"
        case forecast = "main"
    }
}

struct WeatherVO: Codable {
    var temperature:Double
    var pressure:Int
    var humidity:Int
    var minTemperature:Double
    var maxTemperature:Double
    
    enum CodingKeys: String, CodingKey
    {
        case temperature = "temp"
        case pressure
        case humidity
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}

struct WeatherInfoVO: Codable {
    var id:Int
    var main:String
    var description:String
    var icon:String
}

struct WindVO: Codable {
    var speed:Double
    var degree: Double
    
    enum CodingKeys: String, CodingKey
    {
        case speed
        case degree = "deg"
    }
}
//get list of all possible locations
extension Country {
    static public func getHardcodedData() -> [Country] {
        
        var countries:[Country] = []
        
        //add some european countries
        let germany = Country(name:"Germany")
        
        germany.cities += [City(name: "Berlin")]
        germany.cities += [City(name: "Hamburg")]
        germany.cities += [City(name: "Munich")]
        germany.cities += [City(name: "Cologne")]
        
        countries.append(germany)
        
        let italy = Country(name: "Italy")
        
        italy.cities += [City(name:"Rome")]
        italy.cities += [City(name:"Milan")]
        italy.cities += [City(name:"Naples")]
        italy.cities += [City(name:"Venice")]
        
        countries.append(italy)
        
        let france = Country(name:"France")
        
        france.cities += [City(name:"Paris")]
        france.cities += [City(name:"Marseille")]
        france.cities += [City(name:"Lyon")]
        
        countries.append(france)
        
        let uk = Country(name:"United Kingdom")
        
        uk.cities += [City(name:"London")]
        uk.cities += [City(name:"Birmingham")]
        uk.cities += [City(name:"Leeds")]
        uk.cities += [City(name:"Glasgow")]
        
        countries.append(uk)
        
        let spain = Country(name:"Spain")
        
        spain.cities += [City(name:"Madrid")]
        spain.cities += [City(name:"Barcelona")]
        spain.cities += [City(name:"Valencia")]
        
        countries.append(spain)
        
        return countries
    }
}

public class Forecast {
    var date:Date
    var weather:String = "undefined"
    var temperature = 100
    
    public init(date:Date, weather: String, temperature: Int) {
        self.date = date
        self.weather = weather
        self.temperature = temperature
    }
}

public class DailyForecast : Forecast {
    var isWholeDay = false
    var minTemp = -100
    var maxTemp = 100
}


public class LocationForecast {
    
    public static let degreeSymbol = "°"
    
    var location:Location?
    var weather:String?
    
    var forecastForToday:[Forecast]?
    var forecastForNextDays:[DailyForecast]?
    
    // create dummy data, to render it in the UI
    static func getTestData() -> LocationForecast {
        
        let aMinute = 60
        
        let location = Location(city: City.NewYork)
        let forecast = LocationForecast()
        
        forecast.location = location
        forecast.weather = "Sunny"
        
        //today
        let today = Date().midnight
      
        var detailedForecast:[Forecast] = []

        for i in 0...23 {
            detailedForecast.append(Forecast(date: today.addingTimeInterval(TimeInterval(60 * aMinute * i)), weather: "Sunny",temperature: 25))
        }
        
        forecast.forecastForToday = detailedForecast
        
        
        let tomorrow = DailyForecast(date: today.tomorrow, weather: "Sunny",temperature: 25)
        tomorrow.isWholeDay = true
        tomorrow.minTemp = 23
        tomorrow.maxTemp = 27
        
        let afterTomorrow = DailyForecast(date: tomorrow.date.tomorrow, weather: "partly_cloudy",temperature: 25)
        afterTomorrow.isWholeDay = true
        afterTomorrow.minTemp = 24
        afterTomorrow.maxTemp = 28
        
        forecast.forecastForNextDays = [tomorrow, afterTomorrow]

        return forecast
    }
    
    static func getImageFor(weather:String) -> UIImage {
        switch weather.lowercased() {
        case "sunny":
            return #imageLiteral(resourceName: "sunny")
        case "rain":
            fallthrough
        case "rainy":
            return #imageLiteral(resourceName: "rain")
        case "snow":
            return #imageLiteral(resourceName: "snow")
        case "cloudy":
            return #imageLiteral(resourceName: "cloudy")
        case "partly_cloudy":
            return #imageLiteral(resourceName: "partly_cloudy")
        default:
            return #imageLiteral(resourceName: "sunny")
        }
    }
}



