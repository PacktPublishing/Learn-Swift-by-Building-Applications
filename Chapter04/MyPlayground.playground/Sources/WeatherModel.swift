import Foundation

public protocol WeatherModelObserver {
    func modelHasChanged(model:WeatherModel)
}

public class WeatherModel {
    private var weather:Weather
    public var modelObserver:WeatherModelObserver?
    
    public init(weather:Weather) {
        self.weather = weather
    }
    
    public func setNewWeater(weather:Weather) {
        print("[Model] The model has been changed.")
        self.weather = weather
        if modelObserver != nil {
            modelObserver?.modelHasChanged(model: self)
        }
    }
    
    public func getWeather() -> Weather {
        return self.weather
    }
    
    func update() {
        print("[Model] Update the model")
    }
    
}
