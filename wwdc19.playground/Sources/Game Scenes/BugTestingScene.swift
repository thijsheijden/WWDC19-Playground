import PlaygroundSupport
import SpriteKit

public class BugTestingScene: SKScene {
    
    var cameraNode: SKCameraNode?
    
    override public func didMove(to view: SKView) {
        cameraNode = SKCameraNode()
        setupCamera()
    }
    
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
}


