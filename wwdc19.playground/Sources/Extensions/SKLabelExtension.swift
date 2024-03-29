import SpriteKit

extension SKLabelNode {

    func typeOutText(text: String, timeBetweenChars: Double, completion: @escaping () -> Void) {
        var atCharacter: Int = 0
        
        Timer.scheduledTimer(withTimeInterval: timeBetweenChars, repeats: true) { (timer) in
            
            if text[atCharacter] == "/" {
                atCharacter += 1
            }
            
            if text[atCharacter] == "{" {
                atCharacter += 1
                self.text? = ""
            }
            
            while text[atCharacter] == " " {
                self.text?.append(" ")
                atCharacter += 1
                if atCharacter == text.count {
                    timer.invalidate()
                    return
                }
            }
            
            if text[atCharacter] != "/" && text[atCharacter] != "{" {
                self.text?.append(text[atCharacter])
                atCharacter += 1
            }
            
            if atCharacter == text.count {
                timer.invalidate()
                completion()
            }
        }
    }
    
}
