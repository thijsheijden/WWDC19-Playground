import SpriteKit
import GameplayKit

class PlayerNode: SKSpriteNode {
    
    var stateMachine: GKStateMachine?
    
    var idleState: IdleState?
    var runningState: RunningState?
    
    var left: Bool = false
    var right: Bool = false
    
    var horizontalMovementSpeed: CGFloat = 0.0
    
    var runMovementSpeed: CGFloat = 5.0
    
    func getMovementSpeed() {
        switch (left, right) {
        case (true, false):
            horizontalMovementSpeed = -runMovementSpeed
            GameVariables.playerPointingDirection = "left"
            stateMachine?.enter(RunningState.self)
            movePlayer()
        case (false, true):
            horizontalMovementSpeed = runMovementSpeed
            GameVariables.playerPointingDirection = "right"
            stateMachine?.enter(RunningState.self)
            movePlayer()
        default:
            horizontalMovementSpeed = 0.0
            stateMachine?.enter(IdleState.self)
        }
    }
    
    func movePlayer() {
        self.position.x = self.position.x + horizontalMovementSpeed
    }
    
    func setupPlayerNode(texture: SKTexture?, size: CGSize, position: CGPoint) {
        self.texture = texture
        self.size = size
        self.position = position
    }
    
    func setupStateMachine() {
        idleState = IdleState(with: self)
        runningState = RunningState(with: self)
        stateMachine = GKStateMachine(states: [idleState!, runningState!])
        stateMachine?.enter(IdleState.self)
    }
    
}
