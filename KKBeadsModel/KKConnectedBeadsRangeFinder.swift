import Foundation

class KKConnectedBeadsRangeFinder {

	private func _findHorizontalConnectedRanges(_ beadsMap :[[Int]]) -> [KKConnectedBeadsRange] {
		var connectedBeadsRanges = [KKConnectedBeadsRange]()
		let rowCount = beadsMap.count
		let columnCount = beadsMap[0].count
		for y in 0..<rowCount {
			var row :[Int] = beadsMap[y]
			var x = 0
			while true {
				if x >= columnCount {
					break
				}
				let typeOfCurrentBead = row[x]
				let tmp = KKConnectedBeadsRange(typeOfCurrentBead)
				tmp.beads.append(KKBeadPosition(x: x, y: y))
				var offset = 1
				while true {
					if x + offset >= columnCount {
						break
					}
					let typeOfNextBead = row[x+offset];
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

	private func _findVerticalConnectedRanges(_ beadsMap :[[Int]]) -> [KKConnectedBeadsRange] {
		var connectedBeadsRanges = [KKConnectedBeadsRange]()
		let rowCount = beadsMap.count
		let columnCount = beadsMap[0].count
		for x in 0..<columnCount {
			var y = 0
			while true {
				if y >= rowCount {
					break
				}
				let typeOfCurrentBead :Int = (beadsMap[y])[x]
				let tmp = KKConnectedBeadsRange(typeOfCurrentBead)
				tmp.beads.append(KKBeadPosition(x: x, y: y))
				var offset = 1
				while true {
					if y + offset >= rowCount {
						break
					}
					let nextType :Int = (beadsMap[y+offset])[x]
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

	private func _mergeFoundRanges(_ ranges :[KKConnectedBeadsRange]) -> [KKConnectedBeadsRange] {
		var unhandledRanges = ranges
		var handledRanges = [KKConnectedBeadsRange]()
		while unhandledRanges.count > 0 {
			var currentRange = unhandledRanges[0]
			unhandledRanges.remove(at: 0)
			var indexes :[Int] = [Int]()
			func checkIfOverlap () -> Bool {
				var newOverlapFound = false
				for i:Int in 0..<unhandledRanges.count {
					if indexes.contains(i) {
						continue
					}
					let anotherRange = unhandledRanges[i]
					if anotherRange.type != currentRange.type {
						continue
					}
					let expandedRange = currentRange.expandedRange
					var found = false
					for bead in anotherRange.beads {
						if expandedRange.contains(bead) {
							found = true
							break
						}
					}
					if found {
						for bead in anotherRange.beads {
							if currentRange.beads.contains(bead) == false {
								currentRange.beads.append(bead)
							}
						}
						newOverlapFound = true
						indexes.append(i)
					}
				}
				return newOverlapFound
			}
			var newOverlapFound = true
			while newOverlapFound {
				newOverlapFound = checkIfOverlap()
			}
			if indexes.count > 0 {
				let sortedIndexes = indexes.sorted {$0 > $1}
				for i in sortedIndexes {
					unhandledRanges.remove(at: i)
				}
			}
			handledRanges.append(currentRange)
		}
		return handledRanges
	}

	func findConnectedBeads(_ beadsMap :[[Int]]) -> [KKConnectedBeadsRange] {
		var connectedBeadsRanges = [KKConnectedBeadsRange]()
		if beadsMap.count == 0 {
			return connectedBeadsRanges
		}
		connectedBeadsRanges += self._findHorizontalConnectedRanges(beadsMap)
		connectedBeadsRanges += self._findVerticalConnectedRanges(beadsMap)
		connectedBeadsRanges = self._mergeFoundRanges(connectedBeadsRanges)
		return connectedBeadsRanges
	}
}
