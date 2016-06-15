import XCTest

class KKBeadsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFindRange() {
		func findRanges(_ m :[[Int]]) -> Int {
			var f = KKConnectedBeadsRangeFinder()
			let r = f.findConnectedBeads(m as [[Int]])
			return r.count
		}

		let m0 = [
			[1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1]]
		XCTAssert(findRanges(m0) == 1)

		let m1 = [
			[2,1,1,1,1,1,4],
			[2,1,3,3,3,3,4],
			[2,1,1,4,1,4,4]]
		XCTAssert(findRanges(m1) == 4)

		let m2 = [
			[2,1,1,1,1,1,1],
			[2,1,1,1,1,1,1],
			[2,1,1,1,1,1,1]
		]
		XCTAssert(findRanges(m2) == 2)

		let m3 = [
			[2,1,2,1,2,1,2],
			[1,2,1,2,1,2,1],
			[2,1,2,1,2,1,2]
		]
		XCTAssert(findRanges(m3) == 0)

		let m4 = [
			[1,1,1,2,2,2,2],
			[3,3,3,4,4,4,4],
			[1,1,1,2,2,2,2]
		]
		XCTAssert(findRanges(m4) == 6)

		let m5 = [
			[1,1,1,1,1,1,1],
			[1,3,3,4,4,4,1],
			[1,1,1,1,1,1,1]
		]
		XCTAssert(findRanges(m5) == 2)

		let m6 = [
			[1,1,1,2,1,1,1],
			[1,1,1,2,1,1,1],
			[1,1,1,2,1,1,1]
		]
		XCTAssert(findRanges(m6) == 3)

		let m7 = [
			[1,2,2,2,2,2,2],
			[1,2,2,2,2,2,2],
			[1,1,1,1,1,1,1],
			[2,2,2,2,2,2,1],
			[2,2,2,2,2,2,1],
		]
		XCTAssert(findRanges(m7) == 3)

		let m8 = [
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
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
