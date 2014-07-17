import UIKit
import SpriteKit


class GameViewController: UIViewController,
	GameSceneDelegate,
	GameIntroSceneDelegate,
	GameEndSceneDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		let skView = self.view as SKView
		var scene = GameIntroScene(size: self.view.bounds.size)
		scene.gameDelegate = self
		scene.scaleMode = .AspectFill
		skView.presentScene(scene)
	}

	func gameScene(gameScene:GameScene!, didEndWithScore score:Int) {
		let skView = self.view as SKView
		var scene = GameEndScene(size: self.view.bounds.size, score: score)
		scene.gameDelegate = self
		scene.scaleMode = .AspectFill
		var transition :SKTransition = SKTransition.crossFadeWithDuration(1.0)
		skView.presentScene(scene, transition: transition)
	}

	func startGame() {
		let skView = self.view as SKView
		var scene = GameScene(size: self.view.bounds.size)
		scene.gameDelegate = self
		scene.scaleMode = .AspectFill
		var transition :SKTransition = SKTransition.crossFadeWithDuration(1.0)
		skView.presentScene(scene, transition: transition)
	}

	func gameIntroSceneDidStart(scene :GameIntroScene) {
		self.startGame()
	}

	func gameEndSceneDidWantPlayAgain(scene :GameEndScene) {
		self.startGame()
	}

	override func shouldAutorotate() -> Bool {
		return true
	}

	override func supportedInterfaceOrientations() -> Int {
		return Int(UIInterfaceOrientationMask.Portrait.toRaw())
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
