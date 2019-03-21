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
            horizontalMovementSpeed = -runMovementSpeed
            GameVariables.playerPointingDirection = "left"
            stateMachine?.enter(RunningState.self)
            jumpPlayer()
            movePlayer()
        case (false, true, true):
            horizontalMovementSpeed = runMovementSpeed
            GameVariables.playerPointingDirection = "right"
            stateMachine?.enter(RunningState.self)
            jumpPlayer()
            movePlayer()
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
            self.physicsBody?.applyImpulse(CGVector(dx: horizontalMovementSpeed*5, dy: 200))
            currentlyTouchingGround = false
        }
    }
    
    func jumpPadTouched() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 350.0))
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
        self.physicsBody?.collisionBitMask = GameVariables.ColliderType.platform.rawValue | GameVariables.ColliderType.nextLevelDoor.rawValue
        self.physicsBody?.contactTestBitMask = GameVariables.ColliderType.platform.rawValue | GameVariables.ColliderType.nextLevelDoor.rawValue
    }
    
}
