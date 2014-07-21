import Foundation
import AVFoundation
import AudioToolbox

enum SoundEngineBGM {
	case bgm1
	case bgm2
	func toString() -> String {
		switch self {
		case bgm1:
			return "bgm1"
		case bgm2:
			return "bgm2"
		}
	}
}

class SoundEngine {
	var player :AVAudioPlayer?

	class func sharedEngine() -> SoundEngine {
		struct Privates {
			static let engine = SoundEngine()
		}
		return Privates.engine
	}

	func startBGM(bgm:SoundEngineBGM) {
		let url = NSBundle.mainBundle().URLForResource(bgm.toString(), withExtension: "mp3")
		self.player = AVAudioPlayer(contentsOfURL: url, error: nil)
		self.player!.volume = 0.5
		self.player!.numberOfLoops = -1
		self.player!.play()
	}

	func stopBGM() {
		self.player?.stop()
		self.player = nil
	}
}
