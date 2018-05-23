import Foundation

public protocol WeatherViewListner {
    func showWeather(forDate:Date)
}

public class WeatherView {
    private var toNotify:WeatherViewListner?
    private var location:String
    private var date:Date
    private var dateFormatter:DateFormatter
    
    public init(location:String, date:Date, listener:WeatherViewListner?) {
        self.location = location
        self.date = date
        self.toNotify = listener
        
        self.dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
//        DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd", options: 0, locale: Locale(identifier: "en_US"))
        
    }
    
    public func simulateUserAction() {
        print("[View] Detect user interactions and react.")
        // update the visual part
        // and notify the controller
        if toNotify != nil {
            toNotify?.showWeather(forDate: Date())
        }
    }
    
    public func draw() {
        let d = self.dateFormatter.string(from: self.date)
        print("[View] \(d) - \(self.location) =>")
    }
    
    public func refresh(location:String) {
        print("[View] The view is updated and will be redrawn")
        
        draw()
    }
}
