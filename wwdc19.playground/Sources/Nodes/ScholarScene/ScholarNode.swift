import SpriteKit

class ScholarNode: SKSpriteNode {
    
    // The maximum and minimum X values for the platform the scholarNode is on
    var maxX: CGFloat?
    var minX: CGFloat?
    
    // The scholar node's movement speed
    var movementSpeed: CGFloat = CGFloat.random(in: 1 ... 4)
    
    // The variable which stores movement speed when paused
    var pausedMovementSpeed: CGFloat = 0.0
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: SKColor.white, size: size)
        self.isUserInteractionEnabled = true
        setupPhysics(texture: texture, size: size)
        setMovingTextures()
    }
    
    // Setting up the scholar node's physics body
    func setupPhysics(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.scholar.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.player.rawValue | GameVariables.ColliderType.platform.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.player.rawValue | GameVariables.ColliderType.platform.rawValue
    }
    
    // Setting the textures for when the scholar moves
    func setMovingTextures() {
    }
    
    // Setting the movement boundaries for this scholar node
    func setMovementBoundaries(minX: CGFloat, maxX: CGFloat) {
        self.maxX = maxX - 10.0
        self.minX = minX + 10.0
    }
    
    // Moving on the platform in the direction of Tim
    func moveOnPlatform() {
        if self.position.x + movementSpeed < maxX ?? 0.0 && self.position.x + movementSpeed > minX ?? 0.0 {
            self.position.x += movementSpeed
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.physicsBody?.affectedByGravity = false
        self.pausedMovementSpeed = movementSpeed
        movementSpeed = 0.0
    }
    
    override func mouseDragged(with event: NSEvent) {
        let deltaX = event.deltaX
        let deltaY = event.deltaY
        
        self.position.x += deltaX * 1.5
        self.position.y -= deltaY * 1.5
    }
    
    override func mouseUp(with event: NSEvent) {
        self.physicsBody?.affectedByGravity = true
        self.movementSpeed = pausedMovementSpeed
    }
    
    // Method which checks where tim is and then changes the movement speed to go that direction, also checks wether its about to fall off a platform in case it is on a platform
    func checkWhereTimIs(timPosition: CGPoint) {
        if self.position.x >= timPosition.x {
            if movementSpeed > 0 {
                movementSpeed *= -1
            }
        } else if self.position.x < timPosition.x {
            if movementSpeed < 0 {
                movementSpeed *= -1
            }
        }
        moveOnPlatform()
    }
}
