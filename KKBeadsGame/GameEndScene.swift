import SpriteKit

protocol GameEndSceneDelegate {
	func gameEndSceneDidWantPlayAgain(_ scene: GameEndScene)
	func gameEndScene(_ scene: GameEndScene, didWantShareScore score: Int)
}

/** The scene for presenting score within a round. */
class GameEndScene: SKScene {
	internal var gameDelegate: GameEndSceneDelegate!
	private var buttonLabel = SKLabelNode(text: "Play Again!")
	private var shareLabel = SKLabelNode(text: "Share!")
	private var score: Int = 0

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init(size: CGSize, score: Int) {
		super.init(size: size)
		self.score = score

		repeat {
			let backgroud = SKSpriteNode(imageNamed: "welcome.jpg")
			backgroud.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
			let actions = SKAction.sequence([SKAction.scale(to: 1.2, duration: 1.0), SKAction.scale(to: 1.0, duration: 1.0)])
			backgroud.run(SKAction.repeatForever(actions))
			self.addChild(backgroud)
		} while (false)

		var point = CGPoint(x: 160, y: 200)
		let label = SKLabelNode(text: "Score: \(score)")
		label.position = point
		label.fontName = "MarkerFelt-Wide"
		label.fontSize = 32
		label.fontColor = UIColor.white
		self.addChild(label)
		point.y -= 40

		self.buttonLabel.name = "start"
		self.buttonLabel.position = CGPoint(x: 160, y: 140)
		self.buttonLabel.fontSize = 48
		self.buttonLabel.fontName = "MarkerFelt-Wide"
		self.buttonLabel.fontColor = UIColor.cyan

		self.buttonLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.5)])))
		self.addChild(self.buttonLabel)

		self.shareLabel.name = "share"
		self.shareLabel.position = CGPoint(x: 160, y: 80)
		self.shareLabel.fontSize = 30
		self.shareLabel.fontName = "MarkerFelt-Wide"
		self.shareLabel.fontColor = UIColor.cyan

		self.shareLabel.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.5)])))
		self.addChild(self.shareLabel)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first
		let location = touch?.location(in: self)
		let node = self.atPoint(location!)

		if node.name == "start" {
			self.gameDelegate?.gameEndSceneDidWantPlayAgain(self)
		} else if node.name == "share" {
			self.gameDelegate?.gameEndScene(self, didWantShareScore: self.score)
		}
	}


}
