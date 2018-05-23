import Foundation

public class WeatherController {
    public var view:WeatherView?
    public var model:WeatherModel?
    
    public init() {
        
    }
    
    public var location:String {
        get {
            return model?.getWeather().location ?? "Unknown"
        }
    }
    
    public var date:Date {
        get {
            return model?.getWeather().date ?? Date()
        }
    }
}

extension WeatherController:WeatherViewListner {
    public func showWeather(forDate:Date) {
        print("[Controller] Handle all user interactions.")
        
        print("[Controller] If necessary the model is updated.")
        
        model?.update()
    }
}

extension WeatherController:WeatherModelObserver {
    public func modelHasChanged(model:WeatherModel) {
        print("[Controller] The model has been updated.")
        
        print("[Controller] Check if the view should be updated.")
        
        view?.refresh(location: "New York")
    }
}
