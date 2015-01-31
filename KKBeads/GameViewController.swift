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
		SoundEngine.sharedEngine().startBGM(.bgm2)
	}

	func gameScene(gameScene:GameScene!, didEndWithScore score:Int) {
		let skView = self.view as SKView
		var scene = GameEndScene(size: self.view.bounds.size, score: score)
		scene.gameDelegate = self
		scene.scaleMode = .AspectFill
		var transition :SKTransition = SKTransition.crossFadeWithDuration(1.0)
		skView.presentScene(scene, transition: transition)
		SoundEngine.sharedEngine().startBGM(.bgm2)
	}

	func startGame() {
		let skView = self.view as SKView
		var scene = GameScene(size: self.view.bounds.size)
		scene.gameDelegate = self
		scene.scaleMode = .AspectFill
		var transition :SKTransition = SKTransition.crossFadeWithDuration(1.0)
		skView.presentScene(scene, transition: transition)
		SoundEngine.sharedEngine().startBGM(.bgm1)
	}

	func gameIntroSceneDidStart(scene :GameIntroScene) {
		self.startGame()
	}

	func gameEndSceneDidWantPlayAgain(scene :GameEndScene) {
		self.startGame()
	}

	func gameEndScene(scene :GameEndScene, didWantShareScore score:Int) {
		let text = "我剛剛拿球丟清帆，得了 \(score) 分！"
		let controller = UIActivityViewController(activityItems: [text], applicationActivities: [])
		self.presentViewController(controller, animated: true, completion: nil)
	}

	override func shouldAutorotate() -> Bool {
		return true
	}

	override func supportedInterfaceOrientations() -> Int {
		return Int(UIInterfaceOrientationMask.Portrait.rawValue)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
