import Foundation

/**
 * Structure which describes the weather in specific point in time
 * It contians the most important details.
 **/
public struct ForecastData {
   public var hour: Int
   public var temp: Double
   public var minTemp: Double
   public var maxTemp: Double
   public var pressure: Double
   public var humidity: Double
    
   public var clouds: Double
   public var wind: WindData
    
   public var description: String
   public var icon: String?
}

public extension ForecastData {
    init() {
        self.hour = 0
        self.temp = 0
        self.minTemp = 0.0
        self.maxTemp = 0.0
        self.pressure = 0.0
        self.humidity = 0.0
        self.clouds = 0.0
        
        self.wind = WindData(speed: 0, degrees: 0, direction: "none")
        self.description = "Empty object"
        self.icon = nil
    }
}
