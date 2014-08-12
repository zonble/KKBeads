import XCTest

class KKBeadsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFindRange() {
		func findRanges(m :[[Int]]) -> Int {
			var f = KKConnectedBeadsRangeFinder()
			let r = f.findConnectedBeads(m as [[Int]])
			return r.count
		}

		var m0 = [
			[1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1]]
		XCTAssert(findRanges(m0) == 1)

		var m1 = [
			[2,1,1,1,1,1,4],
			[2,1,3,3,3,3,4],
			[2,1,1,4,1,4,4]]
		XCTAssert(findRanges(m1) == 4)

		var m2 = [
			[2,1,1,1,1,1,1],
			[2,1,1,1,1,1,1],
			[2,1,1,1,1,1,1]
		]
		XCTAssert(findRanges(m2) == 2)

		var m3 = [
			[2,1,2,1,2,1,2],
			[1,2,1,2,1,2,1],
			[2,1,2,1,2,1,2]
		]
		XCTAssert(findRanges(m3) == 0)

		var m4 = [
			[1,1,1,2,2,2,2],
			[3,3,3,4,4,4,4],
			[1,1,1,2,2,2,2]
		]
		XCTAssert(findRanges(m4) == 6)

		var m5 = [
			[1,1,1,1,1,1,1],
			[1,3,3,4,4,4,1],
			[1,1,1,1,1,1,1]
		]
		XCTAssert(findRanges(m5) == 2)

		var m6 = [
			[1,1,1,2,1,1,1],
			[1,1,1,2,1,1,1],
			[1,1,1,2,1,1,1]
		]
		XCTAssert(findRanges(m6) == 3)

		var m7 = [
			[1,2,2,2,2,2,2],
			[1,2,2,2,2,2,2],
			[1,1,1,1,1,1,1],
			[2,2,2,2,2,2,1],
			[2,2,2,2,2,2,1],
		]
		XCTAssert(findRanges(m7) == 3)

		var m8 = [
			[1,1,1,1,1,1,2],
			[1,2,2,2,2,2,2],
			[1,1,1,1,1,1,1],
			[2,2,2,2,2,2,1],
			[2,1,1,1,1,1,1],
		]
		XCTAssert(findRanges(m8) == 3)
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
