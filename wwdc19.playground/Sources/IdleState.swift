import GameplayKit
import SpriteKit

class IdleState: GKState {
    
    var player: PlayerNode
    
    var idleTextures: [SKTexture] = [SKTexture(imageNamed: "Idle-1"), SKTexture(imageNamed: "Idle-2")]

    init(with node: PlayerNode) {
        player = node
    }
    
    func setIdleAnimation() {
        let idleAnimation: SKAction = SKAction.animate(with: idleTextures, timePerFrame: 0.5)
        player.run(SKAction.repeatForever(idleAnimation), withKey: GameVariables.idleStatePlayerAnimation)
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState != self {
            player.removeAction(forKey: GameVariables.runningStatePlayerAnimation)
            setIdleAnimation()
        }
    }

}
