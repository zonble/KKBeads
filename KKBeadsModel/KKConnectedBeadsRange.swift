import Foundation

/*! A range of connected beads. */

class KKConnectedBeadsRange {
	internal var type :Int
	internal var beads :[KKBeadPosition]

	init (_ inType: Int) {
		self.type = inType
		self.beads = [KKBeadPosition]()
	}

	var expandedRange :[KKBeadPosition] {
	get {
		var expandedRange = [KKBeadPosition]()
		for bead in self.beads {
			let additionalBeads = [
				KKBeadPosition(x: bead.x-1, y: bead.y),
				KKBeadPosition(x: bead.x+1, y: bead.y),
				KKBeadPosition(x: bead.x, y: bead.y-1),
				KKBeadPosition(x: bead.x, y: bead.y+1)]
			for aBead in additionalBeads {
				if self.beads.contains(aBead) == false {
					expandedRange.append(aBead)
				}
			}
			expandedRange += self.beads
		}
		return expandedRange
	}
	}
}

