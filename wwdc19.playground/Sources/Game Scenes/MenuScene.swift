import PlaygroundSupport
import SpriteKit

public class MenuScene: SKScene {
    
    var startButton: ButtonNode!
        
    override public func didMove(to view: SKView) {
        self.backgroundColor = SKColor.blue
        
        startButton = ButtonNode(texture: SKTexture(imageNamed: "start"), size: CGSize(width: 100, height: 100))
        startButton.position = CGPoint(x: 100.0, y: 100.0)
        startButton.action = { (button) in
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                self.scene!.scaleMode = .aspectFill
                
                // Present the scene
                GameVariables.sceneView.presentScene(scene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2.5))
            }
        }
        self.addChild(startButton)
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }

}


