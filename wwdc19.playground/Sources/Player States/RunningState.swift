import GameplayKit
import SpriteKit

class RunningState: GKState {
    
    var animationKey: String = "runningAnimation"
    
    var player: PlayerNode
    
    var runningTextures: [SKTexture] = [SKTexture(imageNamed: "Idle-1"), SKTexture(imageNamed: "Groep 2"), SKTexture(imageNamed: "Walk-2"), SKTexture(imageNamed: "Groep 1")]
    
    var spritePointingDirection = "right"
    
    required init(with node: PlayerNode) {
        player = node
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState != self {
            player.removeAllActions()
            setRunningAnimation()
        }
    }

    func setRunningAnimation() {

        print("Game variables pointing direction: \(GameVariables.playerPointingDirection)")
        print("RunningState pointing direction: \(spritePointingDirection)")

        if spritePointingDirection != GameVariables.playerPointingDirection {

            let flip = SKAction.scaleX(by: -1.0, y: 1.0, duration: 0.0)
            player.run(flip)
            spritePointingDirection = GameVariables.playerPointingDirection
        }

        let runningAnimation: SKAction = SKAction.animate(with: runningTextures, timePerFrame: 0.1)
        player.run(SKAction.repeatForever(runningAnimation), withKey: animationKey)
    }
    
}
