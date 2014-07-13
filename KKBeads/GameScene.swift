import SpriteKit

class KKBead : SKSpriteNode {
	var type :Int = 0
	class func beadWithType(inType: Int) -> KKBead {
		var bead = KKBead(imageNamed: "ball\(inType)")
		bead.type = inType
		bead.size = CGSizeMake(70, 70)
		return bead
	}
}

class GameScene: SKScene {

	var draggingBead :KKBead?
	var beads = [KKBead]()

	func pointFromBeadPosition(position :KKBeadPosition) -> CGPoint {
		return CGPointMake(300 + Float(position.x) * 70 + 35,
			100 +  Float(position.y) * 70 + 35)
	}

	func pointToBeadPosition(point :CGPoint) -> KKBeadPosition? {
		if point.x < 300 || point.x > 300 + 70 * 6 {
			return nil
		}
		if point.y < 100 || point.y > 100 + 70 * 5 {
			return nil
		}
		var x = Int(point.x / 70)
		var y = Int(point.y / 70)
		return KKBeadPosition(x: x, y: y)
	}

	func beadAtPosition(position :KKBeadPosition) -> KKBead?  {
		var point = self.pointFromBeadPosition(position)
		return self.beadAtPoint(point)
	}

	func beadAtPoint(point :CGPoint) -> KKBead? {
		for bead in beads {
			let frame:CGRect = bead.frame
			if CGRectContainsPoint(frame, point) {
				return bead
			}
		}
		return nil
	}

	func makeBoard() {
		srandomdev()
		for y in 0...4 {
			for x in 0...5 {
				var needToPickAnotherOne = true
				var beadType: Int = random() % 5
				while needToPickAnotherOne {
					if x < 1 || y < 1 {
						needToPickAnotherOne = false
					} else {
						let x1 = self.beadAtPosition(KKBeadPosition(x: x - 1, y: y))!
						let y1 = self.beadAtPosition(KKBeadPosition(x: x, y: y - 1))!
						if x1.type != beadType || y1.type != beadType {
							needToPickAnotherOne = false
						}
					}
					if needToPickAnotherOne {
						beadType = random() % 5
					}
				}
				let bead = KKBead.beadWithType(beadType + 1)
				bead.position = pointFromBeadPosition(KKBeadPosition(x: x, y: y))
				self.addChild(bead)
				self.beads.append(bead)
			}
		}
	}

	override func didMoveToView(view: SKView) {
		self.makeBoard()
	}

	override func touchesEnded(touches: NSSet, withEvent event: UIEvent!)  {
		if self.draggingBead {
			self.draggingBead!.xScale = 1
			self.draggingBead!.yScale = 1
			self.draggingBead!.alpha = 1.0
			self.draggingBead = nil
		}
	}

	override func touchesMoved(touches: NSSet, withEvent event: UIEvent!) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self)
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
				self.draggingBead!.xScale = 1.5
				self.draggingBead!.yScale = 1.5
			}
		}
	}

	override func update(currentTime: CFTimeInterval) {
	}
}
