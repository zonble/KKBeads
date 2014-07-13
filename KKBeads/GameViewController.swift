import UIKit
import SpriteKit

extension SKNode {
	class func unarchiveFromFile(file : NSString) -> SKNode? {
		let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
		var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
		var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)

		archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
		let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
		archiver.finishDecoding()
		return scene
	}
}

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
			let skView = self.view as SKView
			skView.showsFPS = true
			skView.showsNodeCount = true

			skView.ignoresSiblingOrder = true
			scene.scaleMode = .AspectFill
			skView.presentScene(scene)
		}
	}

	override func shouldAutorotate() -> Bool {
		return true
	}

	override func supportedInterfaceOrientations() -> Int {
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
		} else {
			return Int(UIInterfaceOrientationMask.All.toRaw())
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
