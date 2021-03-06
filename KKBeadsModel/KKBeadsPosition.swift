import Foundation

/** Position of a bead. */
class KKBeadPosition {
	var x :Int = NSNotFound
	var y :Int = NSNotFound

	init (x inX :Int, y inY :Int) {
		self.x = inX
		self.y = inY
	}
}

extension KKBeadPosition : Equatable {
}

func == (lhs: KKBeadPosition, rhs: KKBeadPosition) -> Bool {
	return lhs.x == rhs.x && lhs.y == rhs.y
}
