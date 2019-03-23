import PlaygroundSupport
import SpriteKit

public class IntroCutScene: SKScene {
    
    var cameraNode: SKCameraNode?
    
    var cutsceneLabel1: SKLabelNode?
    
    var currentlyOnLine: Int = 0
    
    override public func didMove(to view: SKView) {
        cameraNode = SKCameraNode()
        flipTimHead()
        setupCamera()
//        setupLabel()
        setupAndStartTextNode()
    }
    
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
    // Method to flip tims head and animate him talking
    func flipTimHead() {
        for node in self.children {
            if node.name == "tim-head" {
                node.run(SKAction.scaleX(by: -1.0, y: 1.0, duration: 0.0))
                node.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "tim-cook-head-1"), SKTexture(imageNamed: "tim-cook-head-2")], timePerFrame: 0.1)))
            }
        }
    }
    
    // Method to start the text from being printed
    func setupAndStartTextNode() {
        let textNode = TextLineNode(texture: SKTexture(imageNamed: "text-bubble"), size: CGSize(width: 845, height: 200))
        textNode.position = CGPoint(x: 155, y: 60)
        textNode.textLineNodeLabel?.position.x = textNode.frame.minX - 100.0
        textNode.textLineNodeLabel?.fontSize = 40.0
        textNode.startTypingText(text: GameVariables.firstCutSceneText, timeBetweenChars: 0.1, removeOnCompletion: false) { () -> Void in
            self.presentBugHuntingScene()
        }
        self.addChild(textNode)
    }
    
//    func setupLabel() {
//        cutsceneLabel1 = self.childNode(withName: "text-bubble") as? SKLabelNode
//        cutsceneLabel1?.fontName = "Minecraft"
//        cutsceneLabel1?.fontSize = 50.0
//        cutsceneLabel1?.text? = ""
//        cutsceneLabel1?.preferredMaxLayoutWidth = 300.0
//        cutsceneLabel1?.typeOutText(text: GameVariables.firstCutSceneText, timeBetweenChars: 0.08) { () -> Void in
//            self.presentBugHuntingScene()
//        }
//    }
    
    func presentBugHuntingScene() {
        if let bugHuntingScene = BugHuntingScene(fileNamed: "BugHuntingScene") {
            GameVariables.sceneView.presentScene(bugHuntingScene, transition: SKTransition.reveal(with: .left, duration: 1.0))
        }
    }
    
    func zoomInCamera() {
        cameraNode?.run(SKAction.sequence([SKAction.scale(to: 0.5, duration: 2.5)]))
    }
    
}


