import SpriteKit
import GameplayKit

class JumpingState: GKState {
    
    var animationKey: String = "jumpingAnimation"
    
    var player: PlayerNode
    
    required init(with node: PlayerNode) {
        player = node
    }
    
}
