import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSoundEffect(soundName: String) {
    do {
        let cameraSoundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        audioPlayer = try AVAudioPlayer(contentsOf: cameraSoundEffect)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}
