import SpriteKit

protocol GameIntroSceneDelegate {
	func gameIntroSceneDidStart(scene :GameIntroScene)
}

/** The scene for introducing the game. */
class GameIntroScene :SKScene {
	internal var gameDelegate :GameIntroSceneDelegate!
	private var buttonLabel = SKLabelNode(text: "Start")

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(size: CGSize) {
		super.init(size: size)

		do {
			var backgroud = SKSpriteNode(imageNamed: "welcome.jpg")
			backgroud.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
			let actions = SKAction.sequence([SKAction.scaleTo(1.2, duration: 1.0),SKAction.scaleTo(1.0, duration: 1.0)])
			backgroud.runAction(SKAction.repeatActionForever(actions))
			self.addChild(backgroud)
		} while (false)

		var text = "從前有個人，叫做清帆\n他過很爽！簡直過太爽！\n我們一起來打他吧！"
		var textArray = (text as NSString).componentsSeparatedByString("\n")
		var point = CGPointMake(160, 200)
		for item in textArray {
			let line = item as String
			var label = SKLabelNode(text: line)
			label.position = point
			label.fontSize = 24
			label.fontColor = UIColor.whiteColor()
			self.addChild(label)
			point.y -= 26
		}

		self.buttonLabel.name = "start"
		self.buttonLabel.position = CGPointMake(160, 50)
		self.buttonLabel.fontSize = 72
		self.buttonLabel.fontName = "MarkerFelt-Wide"
		self.buttonLabel.fontColor = UIColor.cyanColor()

		let actions = SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.5), SKAction.scaleTo(1.0, duration: 0.5)])
		self.buttonLabel.runAction(SKAction.repeatActionForever(actions))
		self.addChild(self.buttonLabel)
	}

	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(self)
		var node = self.nodeAtPoint(location)

		if node.name? == "start" {
			self.gameDelegate?.gameIntroSceneDidStart(self)
		}
	}
}
