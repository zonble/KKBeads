import SpriteKit

private class KKBead : SKSpriteNode {
	/** Type of the bead. 1-6. */
	var type :Int = 0
	class func beadWithType(inType: Int) -> KKBead {
		var bead = KKBead(imageNamed: "ball\(inType)")
		bead.type = inType
		bead.size = CGSizeMake(50, 50)
		return bead
	}
}

protocol GameSceneDelegate {
	func gameScene(gameScene:GameScene!, didEndWithScore score:Int)
}

let kBeadTypeCount = 6

/** The main scene. */
class GameScene :SKScene {
	var gameDelegate :GameSceneDelegate!

	private var timeIsUp = false
	private var rangeFinder = KKConnectedBeadsRangeFinder()

	private var draggingBead :KKBead?
	private var cursorBead :KKBead?
	private var bullets = [KKBead]()
	private var timerBar = SKShapeNode(rect: CGRectMake(0, 250, 320, 10))
	private var timerBarBackground = SKShapeNode(rect: CGRectMake(0, 250, 320, 10))
	private var background = SKShapeNode(rect: CGRectMake(0, 0, 320, 250))
	private var comboCount :Int = 0
	private var comboText = SKLabelNode()
	private var messageText = SKLabelNode()
	private var redShapeLayer = SKShapeNode(rect: CGRectMake(0, 0, 320, 420))

	private let maxBallCount = 20
	private var ballCount :Int = 0 {
	didSet {
		self._updateMessage()
	}
	}
	private var score :Int = 0 {
	didSet {
		self._updateMessage()
	}
	}

	private var joeSprite = SKSpriteNode(imageNamed: "joe.jpg")

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(size: CGSize) {
		super.init(size: size)
		self.joeSprite.position = CGPointMake(160, (self.frame.size.height - 250) / 2 + 250)
		let roateAnimation = SKAction.sequence([
			SKAction.rotateByAngle(CGFloat(M_PI / 180 * 10), duration: 1.0),
			SKAction.rotateByAngle(CGFloat(M_PI / 180 * -20), duration: 2.0),
			SKAction.rotateByAngle(CGFloat(M_PI / 180 * 10), duration: 1.0)
			])
		let zoomAnimation = SKAction.sequence([
			SKAction.scaleTo(1.2, duration: 2.0),
			SKAction.scaleTo(1.0, duration: 2.0)
			])
		let group = SKAction.group([
			SKAction.repeatActionForever(roateAnimation),
			SKAction.repeatActionForever(zoomAnimation)
			])
		self.joeSprite.size = CGSizeMake(380, 380)
		self.joeSprite.runAction(group)
		self.addChild(self.joeSprite)

		self.redShapeLayer.position = CGPointMake(0, 160)
		self.redShapeLayer.fillColor = UIColor.redColor()
		self.addChild(self.redShapeLayer)

		self.background.fillColor = UIColor.whiteColor()
		self.addChild(self.background)

		self.timerBar.fillColor = UIColor.greenColor()
		self.timerBarBackground.fillColor = UIColor.blackColor()
		self.addChild(self.timerBarBackground)
		self.addChild(self.timerBar)
		self.comboText.position = CGPointMake(160, 280)
		self.comboText.hidden = true
		self.comboText.fontName = "MarkerFelt-Wide"
		self.comboText.fontColor = UIColor.yellowColor()
		self.addChild(self.comboText)

		self.messageText.position = CGPointMake(160, self.frame.size.height - 50)
		self.messageText.fontName = "MarkerFelt-Wide"
		self.messageText.fontSize = 20
		self._updateMessage()
		self.addChild(self.messageText)
	}

	override func didMoveToView(view: SKView) {
		self.makeBoard()
	}

	private func _endRound() {
		timerBar.removeAllActions()
		timerBar.position = CGPointMake(0, 0)
		self.timeIsUp = false
		self.cursorBead?.removeFromParent()
		self.cursorBead = nil
		if (self.draggingBead != nil) {
			bullets.removeAll(keepCapacity: false)
			self.draggingBead!.alpha = 1.0
			self.draggingBead = nil
			UIApplication.sharedApplication().beginIgnoringInteractionEvents()
			self._delay({self.doErase()}, delayInSeconds: 0.2)
		}
	}

	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		self._endRound()
	}

	override func touchesEnded(touches: NSSet, withEvent event: UIEvent)  {
		self._endRound()
	}

	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		if self.timeIsUp {
			self.touchesCancelled(touches, withEvent: event)
			return
		}
		if self.draggingBead == nil {
			self.touchesCancelled(touches, withEvent: event)
			return
		}
		for touch: AnyObject in touches {
			var location = touch.locationInNode(self)
			if location.x < 35 {
				location.x = 35
			} else if location.x > 285 {
				location.x = 285
			}
			if location.y < 25 {
				location.y = 25
			} else if location.y > 225 {
				location.y = 225
			}

			if let bead = self.cursorBead {
				bead.position = location
			}

			if let bead = self.beadAtPoint(location) {
				if bead !== self.draggingBead? && !bead.hasActions() {
					let to = bead.position
					let from = self.draggingBead!.position
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
				self.addChild(cursorBead!)

				let action = SKAction.moveToX(-320, duration: 6)
				timerBar.runAction(action, completion: {self.timeIsUp = true})
			}
		}
	}
}

//MARK: Animation for erasing beads and combos

extension GameScene {
	private func makeBoard() {
		for y in 0...4 {
			for x in 0...5 {
				srandomdev()
				var beadType: Int = random() % kBeadTypeCount + 1
				var needToPickAnotherOne = true
				while needToPickAnotherOne {
					var sameX = false
					var sameY = false
					if x > 1 {
						let x1 = self.beadAtPosition(KKBeadPosition(x: x - 1, y: y))!
						sameX = x1.type == beadType
					}

					if y > 1 {
						let y1 = self.beadAtPosition(KKBeadPosition(x: x, y: y - 1))!
						sameY = y1.type == beadType
					}

					if !sameX && !sameY {
						needToPickAnotherOne = false
					}

					if needToPickAnotherOne {
						beadType = random() % kBeadTypeCount + 1
					}
				}
				let bead = KKBead.beadWithType(beadType)
				bead.position = pointFromBeadPosition(KKBeadPosition(x: x, y: y))
				self.addChild(bead)
			}
		}
	}

	private func _updateMessage() {
		self.redShapeLayer.alpha = CGFloat(self.ballCount) / CGFloat(60)
		self.messageText.text = "Score: \(self.score) Balls: \(self.ballCount)/\(maxBallCount)"
	}

	private func _delay(call:()->Void, delayInSeconds:NSTimeInterval) {
		let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
		dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
			call()
			})
	}

	private func doMoveBeads() {
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
					var bead = KKBead.beadWithType(random() % kBeadTypeCount + 1)
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

	private func fireBullets() {
		var i :Double = 0
		var duration = 0.2
		for bullet in bullets {
			let x :Int = random() % Int(self.frame.size.width)
			let y :Int = random() % Int(self.frame.size.height)
			bullet.position = CGPointMake(CGFloat(x), CGFloat(y))
			bullet.setScale(2.0)
			bullet.alpha = 0.0
			var wait = SKAction.waitForDuration(i * duration)
			var fire = SKAction.moveTo(joeSprite.position, duration: duration)
			var resize = SKAction.scaleTo(1.0, duration: duration)
			var alpha = SKAction.fadeInWithDuration(duration)
			var sound = SKAction.playSoundFileNamed("sound.caf", waitForCompletion: false)
			bullet.runAction(SKAction.sequence([wait, SKAction.group([resize, fire, alpha]), sound]), completion: {
				let position = CGPointMake(160, (self.frame.size.height - 250) / 2 + 250)
				let position2 = CGPointMake(155, (self.frame.size.height - 250) / 2 + 245)
				let actions = SKAction.sequence([SKAction.moveTo(position2, duration: 0.1), SKAction.moveTo(position, duration: 0.1)])
				self.joeSprite.runAction(actions, completion: {
					self.ballCount += 1
					})
				bullet.removeFromParent()
			})
			self.addChild(bullet)
			i++
		}
		self._delay({
			UIApplication.sharedApplication().endIgnoringInteractionEvents()
			if self.ballCount >= self.maxBallCount {
				self.gameDelegate?.gameScene(self, didEndWithScore: self.score)
			}
			}, delayInSeconds: i * duration)
	}

	private func doErase() {
		var a = self.beadsToPositionArray()
		var ranges = self.rangeFinder.findConnectedBeads(a)

		if ranges.count == 0 {
			self.comboText.hidden = true
			self.comboCount = 0
			if bullets.count == 0 {
				UIApplication.sharedApplication().endIgnoringInteractionEvents()
			} else {
				self.fireBullets()
			}
			return
		}

		var i = 0
		var comboActions = [SKAction]()
		for range in ranges {
			for position in range.beads {
				var bead = self.beadAtPosition(position)!
				let wait = SKAction.waitForDuration(0.2 * Double(i))
				let fade = SKAction.fadeOutWithDuration(0.1)
				let group = SKAction.sequence([wait, fade])
				bead.runAction(group, completion: {bead.removeFromParent()})
				bullets.append(KKBead.beadWithType(bead.type))
			}
			i++
			self.comboCount++
			self.score += self.comboCount * range.beads.count * range.beads.count
		}

		if self.comboCount > 1 {
			self.comboText.hidden = false
		}
		self.comboText.text = "\(self.comboCount) Combo!"

		self._delay({self.doMoveBeads()}, delayInSeconds: 0.2 * Double(i) + 0.1)
	}
}

//MARK: Positioning

extension GameScene {

	private func beadsToPositionArray() -> [[Int]] {
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

	private func pointFromBeadPosition(position :KKBeadPosition) -> CGPoint {
		var x :CGFloat = 10 + CGFloat(position.x) * 50 + 25
		var y :CGFloat = 0 + CGFloat(position.y) * 50 + 25
		return CGPointMake(x, y)
	}

	private func pointToBeadPosition(point :CGPoint) -> KKBeadPosition? {
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

	private func beadAtPosition(position :KKBeadPosition) -> KKBead?  {
		var point = self.pointFromBeadPosition(position)
		return self.beadAtPoint(point)
	}

	private func beadAtPoint(point :CGPoint) -> KKBead? {
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
