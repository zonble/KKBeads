import SpriteKit

protocol GameEndSceneDelegate {
	func gameEndSceneDidWantPlayAgain(scene :GameEndScene)
	func gameEndScene(scene :GameEndScene, didWantShareScore score:Int)
}

/** The scene for presenting score within a round. */
class GameEndScene :SKScene {
	internal var gameDelegate :GameEndSceneDelegate!
	private var buttonLabel = SKLabelNode(text: "Play Again!")
	private var shareLabel = SKLabelNode(text: "Share!")
	private var score :Int = 0

	init(size: CGSize, score:Int) {
		super.init(size: size)
		self.score = score

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
		self.buttonLabel.position = CGPointMake(160, 140)
		self.buttonLabel.fontSize = 48
		self.buttonLabel.fontName = "MarkerFelt-Wide"
		self.buttonLabel.fontColor = UIColor.cyanColor()

		self.buttonLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.5), SKAction.scaleTo(1.0, duration: 0.5)])))
		self.addChild(self.buttonLabel)

		self.shareLabel.name = "share"
		self.shareLabel.position = CGPointMake(160, 80)
		self.shareLabel.fontSize = 30
		self.shareLabel.fontName = "MarkerFelt-Wide"
		self.shareLabel.fontColor = UIColor.cyanColor()

		self.shareLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.5),SKAction.scaleTo(1.0, duration: 0.5)])))
		self.addChild(self.shareLabel)
	}

	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(self)
		var node = self.nodeAtPoint(location)

		if node.name? == "start" {
			self.gameDelegate?.gameEndSceneDidWantPlayAgain(self)
		} else if node.name? == "share" {
			self.gameDelegate?.gameEndScene(self, didWantShareScore: self.score)
		}
	}


}
