import XCTest
@testable import swift_lib

class swift_libTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_lib().text, "Hello, World!")
    }
	
	func testToyDefaultValues() {
		let toy = Toy()
		XCTAssertEqual(toy.name, "Unknown")
		XCTAssertEqual(toy.age, 1)
		XCTAssertEqual(toy.price, 1.0)
	}

	func testToy() {
		let toy = Toy(name: "Rex", age: 2, price:99)
		XCTAssertEqual(toy.name, "Rex")
		XCTAssertEqual(toy.age, 2)
		XCTAssertEqual(toy.price, 99.0)
	}
	//update this for Linux
    static var allTests = [
        ("testExample", testExample),
        ("testToyDefaultValues", testToyDefaultValues),
        ("testToy", testToy),
    ]
}
