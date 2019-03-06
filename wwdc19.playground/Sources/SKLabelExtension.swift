import SpriteKit

extension SKLabelNode {
    
    func typeOutText(text: String) {
        var atCharacter: Int = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            
            while text[atCharacter] == " " {
                self.text?.append(" ")
                atCharacter += 1
                if atCharacter == text.count {
                    timer.invalidate()
                    return
                }
            }
            
            self.text?.append(text[atCharacter])
            print(text[atCharacter])
            atCharacter += 1
            if atCharacter == text.count {
                timer.invalidate()
            }
        }
    }
    
}
