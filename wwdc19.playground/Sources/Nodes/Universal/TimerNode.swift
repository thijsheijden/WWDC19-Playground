import SpriteKit

class TimerNode: SKSpriteNode {
    
    // All the timer phases
    let timerPhases: [SKTexture] = [SKTexture(imageNamed: "timer1"), SKTexture(imageNamed: "timer2"), SKTexture(imageNamed: "timer3"), SKTexture(imageNamed: "timer4"), SKTexture(imageNamed: "timer5"), SKTexture(imageNamed: "timer6"), SKTexture(imageNamed: "timer7"), SKTexture(imageNamed: "timer8"), SKTexture(imageNamed: "timer9")]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: SKColor.white, size: size)
    }
    
    func startTimer() {
        self.run(SKAction.animate(with: timerPhases, timePerFrame: 7.5)) { () -> Void in
            print("Time is up!")
        }
    }
}
