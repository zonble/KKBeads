import SpriteKit

protocol GameIntroSceneDelegate {
	func gameIntroSceneDidStart(_ scene: GameIntroScene)
}

/** The scene for introducing the game. */
class GameIntroScene: SKScene {
	internal var gameDelegate: GameIntroSceneDelegate!
	private var buttonLabel = SKLabelNode(text: "Start")

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(size: CGSize) {
		super.init(size: size)

		do {
			let backgroud = SKSpriteNode(imageNamed: "welcome.jpg")
			backgroud.size = size
			backgroud.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
			let actions = SKAction.sequence([SKAction.scale(to: 1.2, duration: 1.0), SKAction.scale(to: 1.0, duration: 1.0)])
			backgroud.run(SKAction.repeatForever(actions))
			self.addChild(backgroud)
		}

		let text = "從前有個人，叫做清帆\n他過很爽！簡直過太爽！\n我們一起來打他吧！"
		let textArray = (text as NSString).components(separatedBy: "\n")
		var point = CGPoint(x: size.width/2, y: 220)
		for item in textArray {
			let line = item as String
			let label = SKLabelNode(text: line)
			label.position = point
			label.fontSize = 24
			label.fontColor = UIColor.white
			self.addChild(label)
			point.y -= 26
		}

		self.buttonLabel.name = "start"
		self.buttonLabel.position = CGPoint(x: size.width/2, y: 70)
		self.buttonLabel.fontSize = 72
		self.buttonLabel.fontName = "MarkerFelt-Wide"
		self.buttonLabel.fontColor = UIColor.cyan

		let actions = SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.5), SKAction.scale(to: 1.0, duration: 0.5)])
		self.buttonLabel.run(SKAction.repeatForever(actions))
		self.addChild(self.buttonLabel)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first
		let location = touch?.location(in: self)
		let node = self.atPoint(location!)

		if node.name == "start" {
			self.gameDelegate?.gameIntroSceneDidStart(self)
		}
	}
}
