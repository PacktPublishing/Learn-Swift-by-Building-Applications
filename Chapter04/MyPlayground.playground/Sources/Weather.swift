import Foundation

/***
 * Structure which describes the Weather. It contains an array of ForcastData for each hour.
 * The location property contains the location where the forcast is applicable.
 * The date property contains the day of the forcast.
 **/
public struct Weather {
    public var hours: [ForecastData]
    internal (set) public var location: String
    internal (set) public var date: Date
    
    // public initializator, because it should be visible
    public init(hours:[ForecastData], location:String, date:Date) {
        self.hours = hours
        self.location = location
        self.date = date
    }
}

public extension Weather {
    init() {
        self.hours = []
        self.location = "Nowhere"
        self.date = Date()
    }
}
