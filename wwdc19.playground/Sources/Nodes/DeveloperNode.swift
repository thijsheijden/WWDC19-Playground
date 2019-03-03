import SpriteKit

class DeveloperNode: SKSpriteNode {
    
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
    
}
