import UIKit
import SpriteKit


class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let skView = self.view as SKView
		var size = self.view.bounds.size
		var scene = GameScene(size: size)
		scene.scaleMode = .AspectFill
		skView.presentScene(scene)
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
