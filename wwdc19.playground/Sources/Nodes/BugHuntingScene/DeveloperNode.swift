import SpriteKit

class DeveloperNode: SKSpriteNode {
    
    var isBusy: Bool = false
    
    var workingAnimationFrames: [SKTexture] = [SKTexture(imageNamed: "developer2"), SKTexture(imageNamed: "developer3"), SKTexture(imageNamed: "developer4"), SKTexture(imageNamed: "developer5"), SKTexture(imageNamed: "developer6"), SKTexture(imageNamed: "developer7"), SKTexture(imageNamed: "developer8"), SKTexture(imageNamed: "developer9"), SKTexture(imageNamed: "developer10"), SKTexture(imageNamed: "developer11"), SKTexture(imageNamed: "developer12"), SKTexture(imageNamed: "developer13"), ]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: SKColor.white, size: size)
        setupPhysics(texture: texture, size: size)
    }
    
    func setupPhysics(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.developer.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.bug.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.bug.rawValue
    }
    
    // Method which makes this developer busy, meaning he cant be used for bug fixing anymore
    func setDeveloperToBusy() {
        isBusy = true
        self.run(SKAction.repeatForever(SKAction.animate(with: workingAnimationFrames, timePerFrame: 0.1)))
    }
    
}
