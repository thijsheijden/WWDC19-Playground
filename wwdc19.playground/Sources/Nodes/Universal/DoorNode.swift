import SpriteKit

class DoorNode: SKSpriteNode {
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: NSColor.white, size: size)
        setupPhysicsBody(texture: texture, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupPhysicsBody(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.nextLevelDoor.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.player.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.player.rawValue
    }
    
}

