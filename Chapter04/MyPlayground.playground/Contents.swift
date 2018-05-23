//: Playground - noun: a place where people can play

import UIKit

//: struct Car
struct Car {
    var name:String = "missing name"
    var speed = 0
    var maxSpeed = 200
    
    //method
    func getDescription() -> String {
        return "\(self.name) has maximal speed of \(self.maxSpeed)"
    }
    //property - getter (againg method), but it's
    //invoked slightly different
    var description:String {
        get {
            return self.getDescription()
        }
    }
}

var ferrari = Car(name:"Ferrari F40", speed: 280, maxSpeed:320)

print(ferrari.getDescription())
print(ferrari.description)

class Permit {
    var validUntil = 2017
    
    init(validUntil: Int) {
        self.validUntil = validUntil
        
        print("Permit object is constructed")
    }
    
    deinit {
        print("This instance is destroyed.")
    }
}

class Ship {
    var speed = 0
    var isFlying = false
    
    var description:String {
        get {
            return "The ship speed is \(self.speed) and it can\(self.isFlying ? "" : "not") fly."
        }
    }
    
    //designated initializer
    init(speed:Int, isFlying:Bool) {
        self.speed = speed
        self.isFlying = isFlying
    }
    
    //convenience
    convenience init(speed:Int) {
        self.init(speed: speed, isFlying: false);
    }
    
    internal var _id:String = "no-id"
    var serialNumber: String {
        get {
            return self._id
        }
        set {
            _id = newValue
        }
    }
    //read only
    var version: String {
        return "1.0.0"
    }
    
    lazy var permit:Permit = Permit(validUntil: 2100)
    
    static let madeIn = "UK"
    
    //
    func calculateDistance(time:Int) -> Int {
        return self.speed * time
    }
}


//let ship = Ship()
//ship.speed = 10
//ship.isFlying = false
//print(ship.description)

let ship = Ship(speed: 10)
print(ship.description)

ship.serialNumber = "my-first-ship"
print(ship.serialNumber)

print("Ship version: \(ship.version)")

//version is read-only, the next code is causeing compile error
//ship.version = "4.0.0"

print("Ship's permit is valid until \(ship.permit.validUntil)")

//ship.permit = Permit(validUntil:3000)

//class extension
extension Ship {
    convenience init(type:String) {
        if(type == "super-sonic") {
            self.init(speed:2000, isFlying: true);
        } else {
            self.init(speed: 10, isFlying: false);
        }
    }
}

//struct extension
extension Car {
    //no need to add convenience in front
    init(name:String) {
        self.name = name
    }
    
    init(name:String, maxSpeed: Int) {
        self.name = name
        self.maxSpeed = maxSpeed
    }
}

var cars = [Car(), Car(name:"Ferrari"), Car(name: "Tesla", maxSpeed: 320), Car(name:"Porshe", speed:50, maxSpeed: 260)]

var ships = [Ship(speed:20), Ship(type:"super-sonic")]


//add color
extension Car {
    enum Color {
        case red, blue, silver, green, pink, undefined
    }
    
    func getTypicalColor() -> Color {
        if self.name == "Ferrari" {
            return .red
        }
        
        if self.name == "Tesla" {
            return .silver
        }
        
        if self.name == "Tesla Blue" {
            return .blue
        }
        
        return .undefined
    }
}


print(Car(name: "Tesla Blue").getTypicalColor() == Car.Color.blue ? "The car is blue." : "What color is this?")

//extension Ship {
//    static let madeIn = "UK"
//}

extension Car {
    //computed read-only property
    static var bestCarBrand:String {
        get { return "Tesla" }
    }
    //type stored property
    static var totalNumberOfCars = 0
}

print("Made in \(Ship.madeIn)")

//get access to a type metadata
var typeOfShipConstant = type(of: ship)
var typeShip = Ship.self
print("My type is \(typeOfShipConstant)")
print("My type is \(typeShip)")
print("The type of Ship.self is \(type(of: typeShip))")




//: Inheritance


//:static vs class functions
class SuperShip:Ship {
    class func getTypeName() -> String {
        return "SuperShip"
    }
}

class MegaShip:SuperShip {
    override class func getTypeName() -> String {
        return "Mega-SuperShip"
    }
}

print(Ship.madeIn)
MegaShip.getTypeName()

print(SuperShip.getTypeName())
print(MegaShip.getTypeName())


// Weather structures in action
var emptyForecast = ForecastData()
var weather = Weather()
weather = Weather(hours:[emptyForecast], location:"London", date:Date())
print(weather.location)

// SpaceShip inherits Ship
class SpaceShip:Ship {
    var numberOfLazerGuns:Int
    init() {
        //initialize local properties
        self.numberOfLazerGuns = 4
        //initialize the inherited ones
        //calling a designated initalizer
        super.init(speed: 50000, isFlying: true)
        
    }
    
//    override var description:String {
//        get {
//            return "The space ship (🚀) speed is \(self.speed) km/s."
//        }
//    }
    
    override var description:String {
        get {
            return super.description
        }
    }
    
    override func calculateDistance(time: Int) -> Int {
        return super.calculateDistance(time: time) * 2
    }
}

extension SpaceShip {
    convenience init(lazerGuns:Int) {
        //call designated constructor
        self.init()
        self.numberOfLazerGuns = lazerGuns
    }
    
    convenience init(speed:Int, lazerGuns:Int) {
        //call designated constructor
        self.init()
        self.speed = speed
        self.numberOfLazerGuns = lazerGuns
    }
}


var spaceShip = SpaceShip(lazerGuns: 5)
print("SpaceShip speed is \(spaceShip.speed)")

print(spaceShip.description)


print(spaceShip.calculateDistance(time: 60 * 60))



//MVC example
var dc = DateComponents()
dc.year = 2017
dc.month = 7
dc.day = 7
//create a date
let coolDate = Calendar.current.date(from: dc)!

var newYourWeather = Weather(hours:[emptyForecast], location: "New York", date:  coolDate)
var sanFranciscoWeather = Weather(hours:[emptyForecast], location: "San Francisco", date: coolDate )

var model = WeatherModel(weather: newYourWeather)
var controller = WeatherController()
//the controller needs a model
controller.model = model
model.modelObserver = controller

var view = WeatherView(location: controller.location, date: controller.date, listener: controller)

//the controller needs a view
controller.view = view

//initial view rendering
view.draw()

//simulate model update and the view is updated if needed
model.setNewWeater(weather: sanFranciscoWeather)

//simulate user action and the model will be updated if needed
view.simulateUserAction()


