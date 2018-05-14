import SpriteKit

private class KKBead: SKSpriteNode {
	/** Type of the bead. 1-6. */
	var type: Int = 0

	class func beadWithType(_ inType: Int) -> KKBead {
		let bead = KKBead(imageNamed: "ball\(inType)")
		bead.type = inType
		bead.size = CGSize(width: 50, height: 50)
		return bead
	}
}

protocol GameSceneDelegate {
	func gameScene(_ gameScene: GameScene!, didEndWithScore score: Int)
}

let kBeadTypeCount = 6

/** The main scene. */
class GameScene: SKScene {
	var gameDelegate: GameSceneDelegate!

	fileprivate var timeIsUp = false
	fileprivate var rangeFinder = KKConnectedBeadsRangeFinder()

	fileprivate var draggingBead: KKBead?
	fileprivate var cursorBead: KKBead?
	fileprivate var bullets = [KKBead]()
	fileprivate var timerBar = SKShapeNode(rect: CGRect(x: 0, y: 250, width: 320, height: 10))
	fileprivate var timerBarBackground = SKShapeNode(rect: CGRect(x: 0, y: 250, width: 320, height: 10))
	fileprivate var background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 320, height: 250))
	fileprivate var comboCount: Int = 0
	fileprivate var comboText = SKLabelNode()
	fileprivate var messageText = SKLabelNode()
	fileprivate var redShapeLayer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 320, height: 420))

	fileprivate let maxBallCount = 20
	fileprivate var ballCount: Int = 0 {
		didSet {
			self._updateMessage()
		}
	}
	fileprivate var score: Int = 0 {
		didSet {
			self._updateMessage()
		}
	}

	fileprivate var joeSprite = SKSpriteNode(imageNamed: "joe.jpg")

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(size: CGSize) {
		super.init(size: size)
		self.joeSprite.position = CGPoint(x: 160, y: (self.frame.size.height - 250) / 2 + 250)
		let roateAnimation = SKAction.sequence([
			SKAction.rotate(byAngle: CGFloat(M_PI / 180 * 10), duration: 1.0),
			SKAction.rotate(byAngle: CGFloat(M_PI / 180 * -20), duration: 2.0),
			SKAction.rotate(byAngle: CGFloat(M_PI / 180 * 10), duration: 1.0)
		])
		let zoomAnimation = SKAction.sequence([
			SKAction.scale(to: 1.2, duration: 2.0),
			SKAction.scale(to: 1.0, duration: 2.0)
		])
		let group = SKAction.group([
			SKAction.repeatForever(roateAnimation),
			SKAction.repeatForever(zoomAnimation)
		])
		self.joeSprite.size = CGSize(width: 380, height: 380)
		self.joeSprite.run(group)
		self.addChild(self.joeSprite)

		self.redShapeLayer.position = CGPoint(x: 0, y: 160)
		self.redShapeLayer.fillColor = UIColor.red
		self.addChild(self.redShapeLayer)

		self.background.fillColor = UIColor.white
		self.addChild(self.background)

		self.timerBar.fillColor = UIColor.green
		self.timerBarBackground.fillColor = UIColor.black
		self.addChild(self.timerBarBackground)
		self.addChild(self.timerBar)
		self.comboText.position = CGPoint(x: 160, y: 280)
		self.comboText.isHidden = true
		self.comboText.fontName = "MarkerFelt-Wide"
		self.comboText.fontColor = UIColor.yellow
		self.addChild(self.comboText)

		self.messageText.position = CGPoint(x: 160, y: self.frame.size.height - 50)
		self.messageText.fontName = "MarkerFelt-Wide"
		self.messageText.fontSize = 20
		self._updateMessage()
		self.addChild(self.messageText)
	}

	override func didMove(to view: SKView) {
		self.makeBoard()
	}

	private func _endRound() {
		timerBar.removeAllActions()
		timerBar.position = CGPoint(x: 0, y: 0)
		self.timeIsUp = false
		self.cursorBead?.removeFromParent()
		self.cursorBead = nil
		if (self.draggingBead != nil) {
			bullets.removeAll(keepingCapacity: false)
			self.draggingBead!.alpha = 1.0
			self.draggingBead = nil
			UIApplication.shared.beginIgnoringInteractionEvents()
			self._delay({ self.doErase() }, delayInSeconds: 0.2)
		}
	}

	override func touchesCancelled(_ touches: Set<UITouch>!, with event: UIEvent!) {
		self._endRound()
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self._endRound()
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.timeIsUp {
			self.touchesCancelled(touches, with: event)
			return
		}
		if self.draggingBead == nil {
			self.touchesCancelled(touches, with: event)
			return
		}
		for touch: AnyObject in touches {
			var location = touch.location(in: self)
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
				if bead !== self.draggingBead && !bead.hasActions() {
					let to = bead.position
					let from = self.draggingBead!.position
					self.draggingBead!.position = to
					let action = SKAction.move(to: from, duration: 0.1)
					bead.run(action)
				}
			}
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch: AnyObject in touches {
			let location = touch.location(in: self)
			if let bead = self.beadAtPoint(location) {
				self.draggingBead = bead
				self.draggingBead!.alpha = 0.5

				self.cursorBead = KKBead.beadWithType(self.draggingBead!.type)
				self.cursorBead!.position = location
				self.addChild(cursorBead!)

				let action = SKAction.moveTo(x: -320, duration: 6)
				timerBar.run(action, completion: { self.timeIsUp = true })
			}
		}
	}
}

//MARK: Animation for erasing beads and combos

extension GameScene {
	fileprivate func makeBoard() {
		for y in 0...4 {
			for x in 0...5 {
				srandomdev()
				var beadType: Int = Int(arc4random()) % kBeadTypeCount + 1
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
						beadType = Int(arc4random()) % kBeadTypeCount + 1
					}
				}
				let bead = KKBead.beadWithType(beadType)
				bead.position = pointFromBeadPosition(KKBeadPosition(x: x, y: y))
				self.addChild(bead)
			}
		}
	}

	fileprivate func _updateMessage() {
		self.redShapeLayer.alpha = CGFloat(self.ballCount) / CGFloat(60)
		self.messageText.text = "Score: \(self.score) Balls: \(self.ballCount)/\(maxBallCount)"
	}

	fileprivate func _delay(_ call: @escaping () -> (), delayInSeconds: TimeInterval) {
		let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: popTime) {
			call()
		}
	}

	private func doMoveBeads() {
		var a = [[KKBead]]()
		for x in 0...5 {
			var col = [KKBead]()
			for y in 0...4 {
				let bead = self.beadAtPosition(KKBeadPosition(x: x, y: y))
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
				let acion = SKAction.move(to: self.pointFromBeadPosition(KKBeadPosition(x: x, y: y)), duration: 0.1)
				bead.run(acion)
				y += 1
			}
			if y < 5 {
				for i in 0..<(5 - y) {
					let bead = KKBead.beadWithType(Int(arc4random()) % kBeadTypeCount + 1)
					bead.position = self.pointFromBeadPosition(KKBeadPosition(x: x, y: 6 + i))
					self.addChild(bead)
					let acion = SKAction.move(to: self.pointFromBeadPosition(KKBeadPosition(x: x, y: y + i)), duration: 0.1)
					bead.run(acion)
				}
			}
			x += 1
		}
		self._delay({ self.doErase() }, delayInSeconds: 0.2)
	}

	private func fireBullets() {
		var i: Double = 0
		let duration = 0.2
		for bullet in bullets {
			let x: Int = Int(arc4random()) % Int(self.frame.size.width)
			let y: Int = Int(arc4random()) % Int(self.frame.size.height)
			bullet.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
			bullet.setScale(2.0)
			bullet.alpha = 0.0
			let wait = SKAction.wait(forDuration: i * duration)
			let fire = SKAction.move(to: joeSprite.position, duration: duration)
			let resize = SKAction.scale(to: 1.0, duration: duration)
			let alpha = SKAction.fadeIn(withDuration: duration)
			let sound = SKAction.playSoundFileNamed("sound.caf", waitForCompletion: false)
			bullet.run(SKAction.sequence([wait, SKAction.group([resize, fire, alpha]), sound]), completion: {
				let position = CGPoint(x: 160, y: (self.frame.size.height - 250) / 2 + 250)
				let position2 = CGPoint(x: 155, y: (self.frame.size.height - 250) / 2 + 245)
				let actions = SKAction.sequence([SKAction.move(to: position2, duration: 0.1), SKAction.move(to: position, duration: 0.1)])
				self.joeSprite.run(actions, completion: {
					self.ballCount += 1
				})
				bullet.removeFromParent()
			})
			self.addChild(bullet)
			i += 1
		}
		self._delay({
			UIApplication.shared.endIgnoringInteractionEvents()
			if self.ballCount >= self.maxBallCount {
				self.gameDelegate?.gameScene(self, didEndWithScore: self.score)
			}
		}, delayInSeconds: i * duration)
	}

	fileprivate func doErase() {
		let a = self.beadsToPositionArray()
		let ranges = self.rangeFinder.findConnectedBeads(a)

		if ranges.count == 0 {
			self.comboText.isHidden = true
			self.comboCount = 0
			if bullets.count == 0 {
				UIApplication.shared.endIgnoringInteractionEvents()
			} else {
				self.fireBullets()
			}
			return
		}

		var i = 0
		_ = [SKAction]()
		for range in ranges {
			for position in range.beads {
				let bead = self.beadAtPosition(position)!
				let wait = SKAction.wait(forDuration: 0.2 * Double(i))
				let fade = SKAction.fadeOut(withDuration: 0.1)
				let group = SKAction.sequence([wait, fade])
				bead.run(group, completion: { bead.removeFromParent() })
				bullets.append(KKBead.beadWithType(bead.type))
			}
			i += 1
			self.comboCount += 1
			self.score += self.comboCount * range.beads.count * range.beads.count
		}

		if self.comboCount > 1 {
			self.comboText.isHidden = false
		}
		self.comboText.text = "\(self.comboCount) Combo!"

		self._delay({ self.doMoveBeads() }, delayInSeconds: 0.2 * Double(i) + 0.1)
	}
}

//MARK: Positioning

extension GameScene {

	fileprivate func beadsToPositionArray() -> [[Int]] {
		var a = [[Int]]()
		for y in 0...4 {
			var row = [Int]()
			for x in 0...5 {
				let bead: KKBead = self.beadAtPosition(KKBeadPosition(x: x, y: y))!
				row.append(bead.type)
			}
			a.append(row)
		}
		return a
	}

	fileprivate func pointFromBeadPosition(_ position: KKBeadPosition) -> CGPoint {
		let x: CGFloat = 10 + CGFloat(position.x) * 50 + 25
		let y: CGFloat = 0 + CGFloat(position.y) * 50 + 25
		return CGPoint(x: x, y: y)
	}

	fileprivate func pointToBeadPosition(_ point: CGPoint) -> KKBeadPosition? {
		if point.x < 10 || point.x > 0 + 50 * 6 {
			return nil
		}
		if point.y < 0 || point.y > 0 + 50 * 5 {
			return nil
		}
		let x = Int(point.x / 50)
		let y = Int(point.y / 50)
		return KKBeadPosition(x: x, y: y)
	}

	fileprivate func beadAtPosition(_ position: KKBeadPosition) -> KKBead? {
		let point = self.pointFromBeadPosition(position)
		return self.beadAtPoint(point)
	}

	fileprivate func beadAtPoint(_ point: CGPoint) -> KKBead? {
		for child in self.children {
			if let bead = child as? KKBead {
				let frame: CGRect = bead.frame
				if frame.contains(point) {
					return bead
				}
			}
		}
		return nil
	}
}
