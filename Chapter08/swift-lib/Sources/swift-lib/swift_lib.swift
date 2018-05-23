struct swift_lib {
    var text = "Hello, World!"
}

public struct Toy {
	public var name 	= "Unknown"
	public var age  	= 1
	public var price 	= 1.0
    
    public init(name: String, age:Int, price:Double) {
        self.name = name
        self.age = age
        self.price = price
    }
}
