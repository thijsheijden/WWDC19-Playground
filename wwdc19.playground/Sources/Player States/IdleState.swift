import GameplayKit
import SpriteKit

class IdleState: GKState {

    var animationKey: String = "idleAnimation"
    
    var player: PlayerNode
    
    var idleTextures: [SKTexture] = [SKTexture(imageNamed: "Idle-1"), SKTexture(imageNamed: "Idle-2")]
    
    required init(with node: PlayerNode) {
        player = node
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState != self {
            player.removeAllActions()
            setIdleAnimation()
        }
    }
    
    func setIdleAnimation() {
        let idleAnimation: SKAction = SKAction.animate(with: idleTextures, timePerFrame: 0.5)
        player.run(SKAction.repeatForever(idleAnimation), withKey: animationKey)
    }
    
}
