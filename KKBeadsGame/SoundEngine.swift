import Foundation
import AudioToolbox

class SoundEngine {
	var hitSound :SystemSoundID = 0

	class func sharedEngine() -> SoundEngine {
		struct Privates {
			static let engine = SoundEngine()
		}
		return Privates.engine
	}

	func playHitSound() {
		if hitSound == 0 {
			let mainBundle = CFBundleGetMainBundle()
			let fileURL = CFBundleCopyResourceURL(mainBundle, "sound", "caf", nil)
			AudioServicesCreateSystemSoundID(fileURL, &self.hitSound)
		}
		AudioServicesPlaySystemSound(hitSound)
	}
}