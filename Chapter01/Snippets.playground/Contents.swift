var text = "Hello world!"
text = "Hey, It's Swift!"

var five = 5
var four = 4
var sum = four + five

//re-declaration from above
//var five = 2 + 3

let helloWorld = "Hello World!"
//helloWorld = "Hello, Swift World!" //the compiler is complaining

//re-declaration from above
//var text:String = "Hello World"

//re-declaration of sum
//var a, b, sum: Double

var greeting: String, age:Int, money:Double

var x:Double = 3.0, b:Bool = true

//re-declaration
//type inference
//var x = 3.0, b = true

//Optionals

var fiveOrNothing: Int? = 5
//we will discuss the if-statement later in this chapter
if let five = fiveOrNothing {
    print(five);
} else {
    print("There is no value!");
}

fiveOrNothing = nil

//we will discuss the if-statement later in this chapter

if let five = fiveOrNothing {
    print(five);
} else {
    print("There is no value!");
}


let number = 5
let divisor = 3
let remainder = number % divisor //remainder is again integer
let quotient = number / divisor // quotient is again integer

let hey = "Hi"
let greetingSwift = hey + " Swift 4!" //operator + concatenates strings


//enum
enum AnEnumeration {
    // the value definitions goes here
}

enum GameInputDevice {
    case keyboard, joystick, mouse
}

var input = GameInputDevice.mouse
//...
//later in the code
input = .joystick

let num = 5
if num % 2 == 0 {
    print("The number \(num) is even.")
} else {
    print("The number \(num) is odd.")
}

var logicalCheck = 7 > 5
if (logicalCheck) {
    //code which will be executed if the logical check is evaluated to true
} else {
    //code which will be executed if the logical check is evaluated to false
}

//loop
let collection = [1, 2, 3]
for variable in collection {
    //do some action
}

//re-use sum from above
sum = 0
for index in 1...10 {
    sum += index
    print("(index)")
}
print("Sum: \(sum)")
//sum is equal to 55

let threeTimes = 3
for _ in 1...threeTimes {
    print("Print this message.")
}

var i = 1
let max = 10
sum = 0
while i <= max {
    sum += i
    i += 1
}
print("Sum: \(sum)")

i = 1
sum = 0
repeat {
    sum += i
    i += 1
} while i <= max
print("Sum: \(sum)")


let point = (1, 1)
switch point {
case let (x, y) where x == y:
    print("X is (x). Y is (y). They have the same value.");
case (1, let y):
    print("X is 1. Y is (y). They could be different.");
case (let x, 1):
    print("X is (x). Y is 1. They could be different.");
case let (x, y) where x > y:
    print("X is (x). Y is (y). X is greater than Y.");
default:
    print("Are you sure?")
}


func printSum() {
    let a = 3
    let b = 4
    print("Sum \(a) + \(b) = \(a + b)")
}

printSum()

func functionName(argumentLabel variableName:String) -> String {
    let returnedValue = variableName + " was passed"
    return returnedValue
}
//here is the function invocation and how the result is returned
let resultOfFunctionCall = functionName(argumentLabel: "Nothing")


func concatenateStrings(_ s1:String, _ s2:String) -> String {
    return s1 + s2
}
let helloSwift = concatenateStrings("Hello ", "Swift!")
// or
concatenateStrings("Hello ", "Swift!")


//define a function which finds the max element and its index in a array of integers
func maxItemIndex(numbers:[Int]) -> (item:Int, index:Int) {
    var index = -1
    var max = Int.min
    //use this fancy notation to attach an index to each item
    for (i, val) in numbers.enumerated() {
        if max < val {
            max = val
            index = i
        }
    }
    
    return (max, index)
}

let maxItemTuple = maxItemIndex(numbers: [12, 2, 6, 3, 4, 5, 2, 10])
if maxItemTuple.index >= 0 {
    print("Max item is \(maxItemTuple.item).")
}
//prints "Max item is 12."


func generateGreeting(greet:String, thing:String = "world") -> String {
    return greet + thing + "!"
}

print(generateGreeting(greet: "Hello "))
print(generateGreeting(greet: "Hello ", thing: " Swift 4"))

func maxValue(_ numbers:Int...) -> Int {
    var max = Int.min
    for v in numbers {
        if max < v {
            max = v
        }
    }
    
    return max
}

print(maxValue(1, 2, 3, 4, 5))
//prints 5


func updateVar(_ x: inout Int, newValue: Int = 5) {
    x = newValue
}

var ten = 10
print(ten)
updateVar(&ten, newValue: 15)
print(ten)

func generateGreeting(_ greeting: String?) -> String {
    guard let greeting = greeting else {
        //there is no greeting, we return something and finish
        return "No greeting :("
    }
    //there is a greeting and we generate a greeting message
    return greeting + " Swift 4!"
}

print(generateGreeting(nil))
print(generateGreeting("Hey"))
