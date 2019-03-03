import SpriteKit
import GameplayKit

class JumpingState: GKState {
    
    var animationKey: String = "jumpingAnimation"
    
    var player: PlayerNode
    
    var spritePointingDirection = "right"
    
    required init(with node: PlayerNode) {
        player = node
    }
    
    var jumpingTextures: [SKTexture] = [SKTexture(imageNamed: "Idle-1"), SKTexture(imageNamed: "Groep 2"), SKTexture(imageNamed: "Walk-2"), SKTexture(imageNamed: "Groep 1")]
    
    func setRunningAnimation() {
        
        if spritePointingDirection != GameVariables.playerPointingDirection {
            
            let flip = SKAction.scaleX(by: -1.0, y: 1.0, duration: 0.1)
            player.run(flip)
            spritePointingDirection = GameVariables.playerPointingDirection
        }
        
        let runningAnimation: SKAction = SKAction.animate(with: jumpingTextures, timePerFrame: 0.01)
        player.run(SKAction.repeatForever(runningAnimation), withKey: animationKey)
    }
    
}
