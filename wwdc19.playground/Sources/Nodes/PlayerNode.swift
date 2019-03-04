import SpriteKit
import GameplayKit

class PlayerNode: SKSpriteNode {
    
    var stateMachine: GKStateMachine?
    
    var idleState: IdleState?
    var runningState: RunningState?
    
    var left: Bool = false
    var right: Bool = false
    
    var jump: Bool = false
    var currentlyTouchingGround: Bool = true
    
    var horizontalMovementSpeed: CGFloat = 0.0
    var runMovementSpeed: CGFloat = 5.0
    
    var verticalMovementSpeed: CGFloat = 0.0
    var jumpSpeed: CGFloat = 10.0
    
    func getMovementSpeed() {
        switch (left, right, jump) {
        case (true, false, false):
            horizontalMovementSpeed = -runMovementSpeed
            GameVariables.playerPointingDirection = "left"
            stateMachine?.enter(RunningState.self)
            movePlayer()
        case (false, true, false):
            horizontalMovementSpeed = runMovementSpeed
            GameVariables.playerPointingDirection = "right"
            stateMachine?.enter(RunningState.self)
            movePlayer()
        case (false, false, true):
            jumpPlayer()
        case (true, false, true):
            jumpPlayer()
        case (false, true, true):
            jumpPlayer()
        default:
            horizontalMovementSpeed = 0.0
            stateMachine?.enter(IdleState.self)
        }
    }
    
    func movePlayer() {
        self.position.x += horizontalMovementSpeed
    }
    
    func jumpPlayer() {
        if currentlyTouchingGround {
            self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 250.0))
            currentlyTouchingGround = false
        }
    }
    
    func setupPlayerNode(texture: SKTexture?, size: CGSize, position: CGPoint) {
        self.texture = texture
        self.size = size
        self.position = position
        setupPlayerPhysics(texture: texture!, size: size)
    }
    
    func setupStateMachine() {
        idleState = IdleState(with: self)
        runningState = RunningState(with: self)
        stateMachine = GKStateMachine(states: [idleState!, runningState!])
        stateMachine?.enter(IdleState.self)
    }
    
    func setupPlayerPhysics(texture: SKTexture, size: CGSize) {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = GameVariables.ColliderType.player.rawValue
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.platform.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.platform.rawValue
    }
    
}