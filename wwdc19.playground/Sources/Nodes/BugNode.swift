import SpriteKit

class BugNode: SKSpriteNode {
    
    var bugData: BugDataStruct?
    
    var canCreatePopup: Bool = true
    
    var maxX: CGFloat?
    var minX: CGFloat?
    
    var movementSpeed: CGFloat = -2.5
    var pausedMovementSpeed: CGFloat = -2.5
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize, bugData: BugDataStruct) {
        super.init(texture: texture, color: SKColor.white, size: size)
        self.bugData = bugData
        isUserInteractionEnabled = true
        setupPhysics(texture: texture, size: size)
    }
    
    func setupPhysics(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.bug.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.platform.rawValue | GameVariables.ColliderType.developer.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.platform.rawValue | GameVariables.ColliderType.developer.rawValue
    }
    
    override func mouseDown(with event: NSEvent) {
        self.physicsBody?.affectedByGravity = false
        self.pausedMovementSpeed = movementSpeed
        movementSpeed = 0.0
    }
    
    override func mouseDragged(with event: NSEvent) {
        let deltaX = event.deltaX
        let deltaY = event.deltaY
        
        self.position.x += deltaX
        self.position.y -= deltaY
    }
    
    override func mouseUp(with event: NSEvent) {
        self.physicsBody?.affectedByGravity = true
        self.movementSpeed = pausedMovementSpeed
    }
    
    func setMovementBoundaries(minX: CGFloat, maxX: CGFloat) {
        self.maxX = maxX - 10.0
        self.minX = minX + 10.0
    }
    
    func moveOnPlatform() {
        if self.position.x + movementSpeed < maxX ?? 0.0 && self.position.x + movementSpeed > minX ?? 0.0 {
            self.position.x += movementSpeed
        } else {
            movementSpeed *= -1
        }
    }
    
    func createPopupNode() -> BugPopupNode {
        let popupNode = BugPopupNode(size: CGSize(width: 500.0, height: 500.0), bugData: self.bugData!)
        return popupNode
    }
}
