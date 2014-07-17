import SpriteKit

protocol GameEndSceneDelegate {
	func gameEndSceneDidWantPlayAgain(scene :GameEndScene)
}

class GameEndScene :SKScene {
	var gameDelegate :GameEndSceneDelegate!
	var buttonLabel = SKLabelNode(text: "Play Again!")

	init(size: CGSize, score:Int) {
		super.init(size: size)

		do {
			var backgroud = SKSpriteNode(imageNamed: "welcome.jpg")
			backgroud.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
			let actions = SKAction.sequence([SKAction.scaleTo(1.2, duration: 1.0),SKAction.scaleTo(1.0, duration: 1.0)])
			backgroud.runAction(SKAction.repeatActionForever(actions))
			self.addChild(backgroud)
		} while (false)

		var point = CGPointMake(160, 200)
		var label = SKLabelNode(text: "Score: \(score)")
		label.position = point
		label.fontName = "MarkerFelt-Wide"
		label.fontSize = 32
		label.fontColor = UIColor.whiteColor()
		self.addChild(label)
		point.y -= 40

		self.buttonLabel.name = "start"
		self.buttonLabel.position = CGPointMake(160, self.frame.size.height - 100)
		self.buttonLabel.fontSize = 48
		self.buttonLabel.fontName = "MarkerFelt-Wide"
		self.buttonLabel.fontColor = UIColor.cyanColor()

		let actions = SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.5),SKAction.scaleTo(1.0, duration: 0.5)])
		self.buttonLabel.runAction(SKAction.repeatActionForever(actions))
		self.addChild(self.buttonLabel)
	}

	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(self)
		var node = self.nodeAtPoint(location)

		if node.name == "start" {
			self.gameDelegate?.gameEndSceneDidWantPlayAgain(self)
		}
	}
}
