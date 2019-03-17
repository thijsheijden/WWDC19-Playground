import SpriteKit

class JumpPadNode: SKSpriteNode {
    
    var active: Bool = true
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: NSColor.white, size: size)
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupPhysicsBody() {
        print("Set up jumppad physics body")
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.jumpPad.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.player.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.player.rawValue
    }
    
    func activated() {
        active = false
        // Run activated animation
        // Go back to default animation
        // Put back to active
    }
    
}

