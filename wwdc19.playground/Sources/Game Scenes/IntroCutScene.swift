import PlaygroundSupport
import SpriteKit

public class IntroCutScene: SKScene {
    
    var cameraNode: SKCameraNode?
    
    var cutsceneLabel1: SKLabelNode?
    
    var currentlyOnLine: Int = 0
    
    override public func didMove(to view: SKView) {
        cameraNode = SKCameraNode()
        setupCamera()
        setupLabel()
    }
    
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
    func setupLabel() {
        cutsceneLabel1 = self.childNode(withName: "cutsceneLabel") as? SKLabelNode
        cutsceneLabel1?.fontName = "Minecraft"
        cutsceneLabel1?.fontSize = 50.0
        cutsceneLabel1?.text? = ""
        cutsceneLabel1?.preferredMaxLayoutWidth = 300.0
        cutsceneLabel1?.typeOutText(text: GameVariables.firstCutSceneText, timeBetweenChars: 0.08) { () -> Void in
            self.presentBugHuntingScene()
        }
    }
    
    func presentBugHuntingScene() {
        if let bugHuntingScene = BugHuntingScene(fileNamed: "BugHuntingScene") {
            GameVariables.sceneView.presentScene(bugHuntingScene, transition: SKTransition.reveal(with: .left, duration: 1.0))
        }
    }
    
    func zoomInCamera() {
        cameraNode?.run(SKAction.sequence([SKAction.scale(to: 0.5, duration: 2.5)]))
    }
    
}


