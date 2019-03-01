import GameplayKit
import SpriteKit

class RunningState: GKState {
    
    var player: PlayerNode
    
    var spritePointingDirection = "right"
    
    var runningTextures: [SKTexture] = [SKTexture(imageNamed: "Idle-1"), SKTexture(imageNamed: "Groep 2"), SKTexture(imageNamed: "Walk-2"), SKTexture(imageNamed: "Groep 1")]
    
    init(with node: PlayerNode) {
        player = node
    }
    
    func setRunningAnimation() {
        
        print("Game variables pointing direction: \(GameVariables.playerPointingDirection)")
        print("RunningState pointing direction: \(spritePointingDirection)")
        
        if spritePointingDirection != GameVariables.playerPointingDirection {
            
            let flip = SKAction.scaleX(by: -1.0, y: 1.0, duration: 0.1)
            player.run(flip)
            spritePointingDirection = GameVariables.playerPointingDirection
        }
        
        let runningAnimation: SKAction = SKAction.animate(with: runningTextures, timePerFrame: 0.1)
        player.run(SKAction.repeatForever(runningAnimation), withKey: GameVariables.runningStatePlayerAnimation)
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState != self {
            player.removeAction(forKey: GameVariables.idleStatePlayerAnimation)
            setRunningAnimation()
        }
    }
    
}
