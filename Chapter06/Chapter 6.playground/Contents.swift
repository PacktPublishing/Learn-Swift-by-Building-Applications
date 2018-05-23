//: Swift 4

//: Chapter 6


//: Generics



struct Item<T> {
    var raw: T
    var description: String
    
    init(raw: T, description:String = "no description") {
        self.raw = raw
        self.description = description
    }
}

var itemInt:Item<Int> = Item(raw: 55, description: "fifty five")
print("This is an int \(itemInt.raw) with description - \(itemInt.description)")

var itemDouble:Item<Double> = Item(raw: 3.14, description: "Pi")
print("This is an int \(itemDouble.raw) with description - \(itemDouble.description)")

//: Arrays

var words = Array<String>(arrayLiteral: "one", "two", "three")
//var words = ["one", "two", "three"]

for word in words {
    print(word)
}

var emptyArrayOfInts = [Int]()
var emptyArrayOfInts2 = Array<Int>()
var emptyArray:[Int] = []

var tenZeros = Array(repeating: 0, count: 10)
print("The number of items is \(tenZeros.count).")


var even = [2, 4, 6]
var odd = [1, 3 ,5]
var concatenated = even + odd
print(concatenated)

var part = concatenated[2...4]
print(part)


//: loop through all items

for value in concatenated {
    print("Item: \(value)")
}

for (index, value) in concatenated.enumerated() {
    print("Item #\(index + 1): \(value)")
}


//: Set

let a = 5
let b = 5

if a.hashValue == b.hashValue {
    print("a == b")
} else {
    print("a != b")
}

var phrases = Set<String>()
phrases.insert("hello")
phrases.insert("world")
phrases.insert("hel" + "lo") //"hello"

for item in phrases {
    print(item)
}

var cars:Set = ["Tesla", "Ferari", "Audi"]

for item in cars {
    print(item)
}

var electricCars:Set = ["Tesla", "Volkswagen"]

var intersection = electricCars.intersection(cars)
print("Intersection: \(intersection)")
//Intersection: ["Tesla"]

var union = electricCars.union(cars)
print("Union: \(union)")
//Union: ["Ferari", "Volkswagen", "Audi", "Tesla"]

var substract = electricCars.subtracting(cars)
print("Substract: \(substract)")
//Substract: ["Volkswagen"]

var symetricDifference = electricCars.symmetricDifference(cars)
print("Symetric difference: \(symetricDifference)")
//Symetric difference: ["Ferari", "Volkswagen", "Audi"]

if electricCars.isSubset(of: union) {
    print("Each set is a subset of the union of all sets.")
}

if union.isSuperset(of: cars) {
    print("The union is super set of all sets.")
}

if electricCars.isDisjoint(with: cars) {
    print("The two sets doesn't have common items.")
} else {
    print("The two sets have at least one common item.")
}

electricCars.isStrictSuperset(of: )

//: Dictionary

var animalsDictionary = Dictionary<String, String>(dictionaryLiteral: ("dog", "🐶"), ("cat", "🐱"))
var animalsDictionaryLiteral = ["dog": "🐶","cat": "🐱"]
//adding a new association
animalsDictionary["bird"] = "🐦"

for association in animalsDictionary {
    print("\(association.key) -> \(association.value)")
}

//all pairs
for (animalName, animalEmoji) in animalsDictionary {
    print("\(animalName) -> \(animalEmoji)")
}

//all keys 
for animalName in animalsDictionary.keys {
    print("\(animalName)")
}
//all values
for animalEmoji in animalsDictionary.values {
    print("\(animalEmoji)")
}

var allEmojis = [String](animalsDictionary.values)


var emptyDict:Dictionary<Int, String> = [:]
var emptyMap = [Int: String]()

//: UICollectionView

import UIKit
import PlaygroundSupport

class CollectionViewController : UICollectionViewController {
    
    //selection handler
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let animal = self.data[indexPath.row]
        print(animal)
    }
    
    
    var data:[String]
    
    init(data:[String], collectionViewLayout layout: UICollectionViewLayout) {
        self.data = data
        super.init(collectionViewLayout: layout)
        
    }
    //this is required and we simply delegate
    required init?(coder aDecoder: NSCoder) {
        self.data = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(AnimalCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //how many items we have in each section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AnimalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AnimalCollectionViewCell
        cell.backgroundColor = .green
        
        let animal = self.data[indexPath.row]
        cell.emoji = animal
        
        if self.dataMap != nil {
            cell.emoji = self.dataMap?[animal]
        } else {
            cell.emoji = animal
        }
 
        return cell
    }
    
    var dataMap:[String:String]?
}

/**
 * Custom UICollectionViewCell which has a label on top.
 */
class AnimalCollectionViewCell :UICollectionViewCell {
    
    private var _label: UILabel
    
    override init(frame: CGRect) {
        let fr = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self._label = UILabel(frame:fr)
        super.init(frame: frame)
        
        _label.text = "?"
        _label.textAlignment = NSTextAlignment.center
        addSubview(_label)
    }
    // used when the UI is initializes from storyboard
    required init?(coder aDecoder: NSCoder) {
        self._label = UILabel()
        super.init(coder:aDecoder)
        
        _label.text = "?"
        
        addSubview(_label)
    }
    
    public var emoji:String? {
        set {
           _label.text = newValue
        }
        
        get {
            return _label.text
        }
    }
}

//: PuzzleViewLayout
class PuzzleViewLayout : UICollectionViewLayout {
    // number of columns in the layout
    var columns: Int = 2
    var padding: CGFloat = 6.0
    //collection of all attributes
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    //size of the content
    var contentHeight: CGFloat  = 0.0
    var contentWidth: CGFloat  = 0.0
    
    override func prepare() {
        layoutAttributes.removeAll()
        
        let insets = collectionView!.contentInset
        self.contentWidth = collectionView!.bounds.width - (insets.left + insets.right)
        
        let columnWidth = self.contentWidth / CGFloat(columns)
        
        var column = 0
        //vertical offset
        var topOffset = [CGFloat](repeating: 0, count: columns)
        //horizontal offset
        var offset = [CGFloat]()
        
        for column in 0 ..< columns {
            offset += [CGFloat(column) * columnWidth]
        }
        
        //consider only the first section
        let section = 0
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
            
            let indexPath = IndexPath(row: item, section: section)
            
            //pick the height of each cell at random
            let height:CGFloat = 70 + CGFloat(arc4random_uniform(25) * 10)
            //use the precalculated values from the previous items
            let frame = CGRect(x: offset[column], y: topOffset[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.layoutAttributes.append(attributes)
            
            //stretch the content view bounds
            self.contentHeight = max(frame.maxY, contentHeight)
            
            //move to the next y position
            topOffset[column] = topOffset[column] + height
            
            //move to the next column and always stay in valid index [0 .. columns - 1]
            column = (column + 1) % columns
        }
        
    }
    //terurn size of the whole view collection
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attrs = [UICollectionViewLayoutAttributes]()
        
        //send all items which are visible in the currecnt rectangle
        for itemAttributes in self.layoutAttributes {
            if itemAttributes.frame.intersects(rect) {
                attrs.append(itemAttributes)
            }
        }
        
        return attrs
    }
    
}


var animals = ["Cat", "Dog", "Bird", "Mouse", "Elephant"]
animals.append("Bear")

var animalsToEmoji = ["Cat": "🐱", "Dog": "🐶", "Bird": "🐦" , "Mouse" : "🐭", "Elephant" :" 🐘","Bear":"🐻"]

var flowLayout:UICollectionViewLayout = UICollectionViewFlowLayout()

//flowLayout.itemSize = CGSize.init(width: 200, height: 200)
//flowLayout.minimumLineSpacing = 50.0
//flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal

flowLayout = PuzzleViewLayout()

var controller = CollectionViewController(data:animals, collectionViewLayout: flowLayout)
controller.dataMap = animalsToEmoji

PlaygroundPage.current.liveView = controller
PlaygroundPage.current.needsIndefiniteExecution = true



//: Protocols

protocol CustomContractProtocol {
    // list of all requremets (methods or properties)
}

struct MyStruct : CustomContractProtocol {
    //all properties 
    
    //all protocol requrements
}

class BaseClass {
    //empty base class
}

class MyClass : BaseClass, CustomContractProtocol {
    //all properties
    
    //all protocol requrements
}


protocol GeoLocationProtocol {
    var long: Double { get set }
    var lat: Double { get set }
    var name: String { get }
    //function which calculates distance to specific geo point
    func calculateDistance(to: GeoLocationProtocol) -> Double
}

protocol InitProtocol {
    init(from: Int)
}

class MyInt : InitProtocol {
    var value:Int
    
    required init(from: Int) {
        //code goes here
        self.value = from
    }
    //failable init
    init?(from: Double) {
        self.value = Int(floor(from))
        
        if(Double(self.value) != from) {
            return nil
        }
    }
}

var myInt = MyInt(from: 3)
var myDouble = MyInt(from: 3.2)

if myDouble != nil {
    print("The value is \(myDouble?.value)")
} else {
    print("The object is nil.")
}


protocol A {
    var a:Int {get}
}

protocol B {
    var b: Int {get}
}
//protocol inheritance
protocol C: A, B {
    var c: Int {get}
}

class MyTuple : C {
    var a: Int = 0
    var b: Int = 0
    var c: Int {
        get {
            return 7
        }
    }
}

func isSpecial(object: A & B) -> Bool {
    return object.a % object.b == 7
}

extension Collection where Iterator.Element : A {
    func toPrettyString() -> String {
        var s = ""
        for a in self {
            s += "\(a.a):)"
        }
        
        return s
    }
}

var arrayTuples = [MyTuple()]
print(arrayTuples.toPrettyString())
