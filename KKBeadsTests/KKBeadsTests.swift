import XCTest

class KKBeadsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFindRange() {
		func findRanges(m:AnyObject[]) -> Int {
			var f = KKConnectedBeadsRangeFinder()
			let r = f.findConnectedBeads(m)
			return r.count
		}
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
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
