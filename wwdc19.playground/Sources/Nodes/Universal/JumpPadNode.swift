import SpriteKit
import AVFoundation

class JumpPadNode: SKSpriteNode {
    
    var active: Bool = true
    
    var activatedTextures: [SKTexture] = [SKTexture(imageNamed: "jumppad1"), SKTexture(imageNamed: "jumppad2"), SKTexture(imageNamed: "jumppad-idle")]
    
    let idleTexture = SKTexture(imageNamed: "jumppad-idle")
    
    // The sound effect audio player
    var audioPlayer: AVAudioPlayer?
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: NSColor.white, size: size)
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.jumpPad.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.player.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.player.rawValue
    }
    
    func activated() {
        active = false
        runJumpAnimation()
    }
    
    func runJumpAnimation() {
        playSound()
        self.run(SKAction.animate(with: activatedTextures, timePerFrame: 0.05)) { () -> Void in
            self.active = true
        }
    }
    
    func playSound() {
        do {
            let cameraSoundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "boingSound", ofType: "mp3")!)
            audioPlayer = try AVAudioPlayer(contentsOf: cameraSoundEffect)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

