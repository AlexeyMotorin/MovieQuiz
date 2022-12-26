

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    func testGetValueInRanded() throws {
        let array = [1, 2, 3, 4]
        let value = array[safe: 0]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 1)
    }
    
    func testGetValueOutRanded() throws {
        let array = [1, 2, 3, 4]
        let value = array[safe: 4]
        
      XCTAssertNil(value)
    
    }

}
