import SpriteKit

class MrClickerNode: SKSpriteNode {
    
    var isCaught: Bool = false
    var timer: Timer?
    
    let pipeLocations: [CGPoint] = [CGPoint(x: -640, y: -240), CGPoint(x: -400, y: -240), CGPoint(x: -160, y: -240), CGPoint(x: 80, y: -240), CGPoint(x: 320, y: -240), CGPoint(x: 560, y: -240)]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: SKColor.white, size: size)
        self.zPosition = -10
        self.isUserInteractionEnabled = true
    }
    
    override func mouseDown(with event: NSEvent) {
        isCaught = true
    }
    
    // Method which starts mr clickers movement
    func startMovingMrClicker() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if !self.isCaught {
                self.getPipeToMoveTo()
            } else {
                timer.invalidate()
            }
        }
    }
    
    // Method which gets the location to move MR clicker to
    func getPipeToMoveTo() {
        let pipeNumber = Int.random(in: 0...5)
        moveMrClicker(location: pipeLocations[pipeNumber])
    }
    
    // Method which does the actual moving
    func moveMrClicker(location: CGPoint) {
        self.run(SKAction.sequence([SKAction.move(to: location, duration: 0.0), SKAction.moveBy(x: 0.0, y: 170, duration: 0.5), SKAction.moveBy(x: 0.0, y: -170, duration: 0.5)]))
    }
}
