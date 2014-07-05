import Foundation

class KKConnectedBeadsRange {
	var type :Int
	var beads :KKBeadPosition[]

	init (_ inType: Int) {
		self.type = inType
		self.beads = KKBeadPosition[]()
	}

	var expandedRange :KKBeadPosition[] {
	get {
		var expandedRange = KKBeadPosition[]()
		for bead in self.beads {
			var additionalBeads = [
				KKBeadPosition(x: bead.x-1, y: bead.y),
				KKBeadPosition(x: bead.x+1, y: bead.y),
				KKBeadPosition(x: bead.x, y: bead.y-1),
				KKBeadPosition(x: bead.x, y: bead.y+1)]
			for aBead in additionalBeads {
				if !contains(self.beads, aBead) {
					expandedRange.append(aBead)
				}
			}
			expandedRange += self.beads
		}
		return expandedRange
	}
	}
}

extension KKConnectedBeadsRange : Printable {
	var description: String {
	get {
		var s = "type: \(self.type) "
		s += "beads: \(self.beads)"
		return s
	}
	}
}
