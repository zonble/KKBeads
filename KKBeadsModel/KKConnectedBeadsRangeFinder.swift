import Foundation

class KKConnectedBeadsRangeFinder {

	func _findHorizontalConnectedRanges(beadsMap :AnyObject[]) -> KKConnectedBeadsRange[] {
		var connectedBeadsRanges = KKConnectedBeadsRange[]()
		let rowCount = beadsMap.count
		let columnCount = beadsMap[0].count
		for y in 0..rowCount {
			var row :Int[] = beadsMap[y] as Int[]
			var x = 0
			while true {
				if x >= columnCount {
					break
				}
				var typeOfCurrentBead = row[x]
				var tmp = KKConnectedBeadsRange(typeOfCurrentBead)
				tmp.beads.append(KKBeadPosition(x: x, y: y))
				var offset = 1
				while true {
					if x + offset >= columnCount {
						break
					}
					var typeOfNextBead = row[x+offset];
					if typeOfNextBead != typeOfCurrentBead {
						break
					}
					tmp.beads.append(KKBeadPosition(x: x+offset, y: y))
					offset += 1
				}
				if tmp.beads.count > 2 {
					connectedBeadsRanges.append(tmp)
				}
				x += offset
			}
		}
		return connectedBeadsRanges
	}

	func _findVerticalConnectedRanges(beadsMap :AnyObject[]) -> KKConnectedBeadsRange[] {
		var connectedBeadsRanges = KKConnectedBeadsRange[]()
		let rowCount = beadsMap.count
		let columnCount = beadsMap[0].count!
		for x in 0..columnCount {
			var y = 0
			while true {
				if y >= rowCount {
					break
				}
				var typeOfCurrentBead :Int = (beadsMap[y] as Int[])[x] as Int
				var tmp = KKConnectedBeadsRange(typeOfCurrentBead)
				tmp.beads.append(KKBeadPosition(x: x, y: y))
				var offset = 1
				while true {
					if y + offset >= rowCount {
						break
					}
					var nextType :Int = (beadsMap[y+offset] as Int[])[x] as Int
					if nextType != typeOfCurrentBead {
						break
					}
					tmp.beads.append(KKBeadPosition(x: x, y: y+offset))
					offset += 1
				}
				if tmp.beads.count > 2 {
					connectedBeadsRanges.append(tmp)
				}
				y += offset
			}
		}
		return connectedBeadsRanges
	}

	func _mergeFoundRanges(ranges :KKConnectedBeadsRange[]) -> KKConnectedBeadsRange[] {
		var unhandledRanges = ranges.copy()
		var handledRanges = KKConnectedBeadsRange[]()
		while unhandledRanges.count > 0 {
			var currentRange = unhandledRanges[0]
			unhandledRanges.removeAtIndex(0)
			var indexes = Int[]()
			for i in 0..unhandledRanges.count {
				var anotherRange = unhandledRanges[i]
				if anotherRange.type != currentRange.type {
					continue
				}
				let expandedRange = currentRange.expandedRange
				var found = false
				for bead in anotherRange.beads {
					if contains(expandedRange, bead) {
						found = true
						break
					}
				}
				if found {
					for bead in anotherRange.beads {
						if !contains(currentRange.beads, bead) {
							currentRange.beads.append(bead)
						}
					}
					indexes.append(i)
				}
			}
			if indexes.count > 0 {
				indexes = sort(indexes).reverse()
				for i in indexes {
					unhandledRanges.removeAtIndex(i)
				}
			}
			handledRanges.append(currentRange)
		}
		return handledRanges
	}

	func findConnectedBeads(beadsMap :AnyObject[]) -> KKConnectedBeadsRange[] {
		var connectedBeadsRanges = KKConnectedBeadsRange[]()
		if beadsMap.count == 0 {
			return connectedBeadsRanges
		}
		connectedBeadsRanges += self._findHorizontalConnectedRanges(beadsMap)
		connectedBeadsRanges += self._findVerticalConnectedRanges(beadsMap)
		connectedBeadsRanges = self._mergeFoundRanges(connectedBeadsRanges)
		return connectedBeadsRanges
	}
}
