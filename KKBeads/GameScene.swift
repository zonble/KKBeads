import SpriteKit

class KKBead : SKSpriteNode {
	var type :Int = 0
	class func beadWithType(inType: Int) -> KKBead {
		var bead = KKBead(imageNamed: "ball\(inType)")
		bead.type = inType
		bead.size = CGSizeMake(50, 50)
		return bead
	}
}

class GameScene: SKScene, SKPhysicsContactDelegate {

	var draggingBead :KKBead?
	var cursorBead :KKBead?
	var rangeFinder = KKConnectedBeadsRangeFinder()

	override func didMoveToView(view: SKView) {
		self.makeBoard()
	}

	func _delay(call:()->Void, delayInSeconds:NSTimeInterval) {
		let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
		dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
			call()
		})
	}

	func doMoveBeads() {
		var a = [[KKBead]]()
		for x in 0...5 {
			var col = [KKBead]()
			for y in 0...4 {
				var bead = self.beadAtPosition(KKBeadPosition(x: x, y: y))
				if let b = bead {
					col.append(b)
				}
			}
			a.append(col)
		}
		var x = 0
		for col in a {
			var y = 0
			for bead in col {
				let acion = SKAction.moveTo(self.pointFromBeadPosition(KKBeadPosition(x: x, y: y)), duration: 0.1)
				bead.runAction(acion)
				y += 1
			}
			if y < 5 {
				for i in 0..<(5-y) {
					var bead = KKBead.beadWithType(random() % 5 + 1)
					bead.position = self.pointFromBeadPosition(KKBeadPosition(x: x, y: 6 + i))
					self.addChild(bead)
					let acion = SKAction.moveTo(self.pointFromBeadPosition(KKBeadPosition(x: x, y: y + i)), duration: 0.1)
					bead.runAction(acion)
				}
			}
			x += 1
		}
		self._delay({self.doErase()}, delayInSeconds: 0.2)
	}

	func doErase() {
		var a = self.beadsToPositionArray()
		var ranges = self.rangeFinder.findConnectedBeads(a)

		if ranges.count == 0 {
			UIApplication.sharedApplication().endIgnoringInteractionEvents()
			return
		}

		var i = 0
		for range in ranges {
			for position in range.beads {
				var bead = self.beadAtPosition(position)!
				let wait = SKAction.waitForDuration(0.2 * Double(i))
				let fade = SKAction.fadeOutWithDuration(0.1)
				let group = SKAction.sequence([wait, fade])
				bead.runAction(group, completion: {bead.removeFromParent()})
			}
			i++
		}
		self._delay({self.doMoveBeads()}, delayInSeconds: 0.2 * Double(i) + 0.1)
	}

	override func touchesEnded(touches: NSSet, withEvent event: UIEvent!)  {
		self.cursorBead?.removeFromParent()
		self.cursorBead = nil
		if self.draggingBead {
			self.draggingBead!.alpha = 1.0
			self.draggingBead = nil
			UIApplication.sharedApplication().beginIgnoringInteractionEvents()
			self.doErase()
		}
	}

	override func touchesMoved(touches: NSSet, withEvent event: UIEvent!) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			if location.x < 10 || location.x > 10 + 50 * 6 {
				return
			}
			if location.y < 0 || location.y > 0 + 50 * 5 {
				return
			}

			if let bead = self.cursorBead {
				bead.position = location
			}

			if let bead = self.beadAtPoint(location) {
				if bead !== self.draggingBead? && !bead.hasActions() {
					let (to:CGPoint, from:CGPoint) = (bead.position, self.draggingBead!.position)
					self.draggingBead!.position = to
					let action = SKAction.moveTo(from, duration: 0.1)
					bead.runAction(action)
				}
			}
		}
	}

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
			if let bead = self.beadAtPoint(location) {
				self.draggingBead = bead
				self.draggingBead!.alpha = 0.5

				self.cursorBead = KKBead.beadWithType(self.draggingBead!.type)
				self.cursorBead!.position = location
				self.addChild(cursorBead)
			}
		}
	}

	override func update(currentTime: CFTimeInterval) {
	}
}

extension GameScene {
	func makeBoard() {
		for y in 0...4 {
			for x in 0...5 {
				srandomdev()
				var beadType: Int = random() % 5 + 1
				var needToPickAnotherOne = true
				while needToPickAnotherOne {
					var sameX = true
					var sameY = true
					if x > 1 {
						let x1 = self.beadAtPosition(KKBeadPosition(x: x - 1, y: y))!
						sameX = x1.type == beadType
					} else {
						sameX = false
					}

					if y > 1 {
						let y1 = self.beadAtPosition(KKBeadPosition(x: x, y: y - 1))!
						sameY = y1.type == beadType
					} else {
						sameY = false
					}

					if !sameX && !sameY {
						needToPickAnotherOne = false
					}

					if needToPickAnotherOne {
						beadType = random() % 5 + 1
					}
				}
				let bead = KKBead.beadWithType(beadType)
				bead.position = pointFromBeadPosition(KKBeadPosition(x: x, y: y))
				self.addChild(bead)
			}
		}
	}
}

extension GameScene {

	func beadsToPositionArray() -> [[Int]] {
		var a = [[Int]]()
		for y in 0...4 {
			var row = [Int]()
			for x in 0...5 {
				let bead :KKBead = self.beadAtPosition(KKBeadPosition(x: x, y: y))!
				row.append(bead.type)
			}
			a.append(row)
		}
		return a
	}

	func pointFromBeadPosition(position :KKBeadPosition) -> CGPoint {
		return CGPointMake(10 + Float(position.x) * 50 + 25,
			0 + Float(position.y) * 50 + 25)
	}

	func pointToBeadPosition(point :CGPoint) -> KKBeadPosition? {
		if point.x < 10 || point.x > 0 + 50 * 6 {
			return nil
		}
		if point.y < 0 || point.y > 0 + 50 * 5 {
			return nil
		}
		var x = Int(point.x / 50)
		var y = Int(point.y / 50)
		return KKBeadPosition(x: x, y: y)
	}

	func beadAtPosition(position :KKBeadPosition) -> KKBead?  {
		var point = self.pointFromBeadPosition(position)
		return self.beadAtPoint(point)
	}

	func beadAtPoint(point :CGPoint) -> KKBead? {
		for child in self.children {
			if let bead = child as? KKBead {
				let frame:CGRect = bead.frame
				if CGRectContainsPoint(frame, point) {
					return bead
				}
			}
		}
		return nil
	}
}
