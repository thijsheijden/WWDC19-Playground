import PlaygroundSupport
import SpriteKit

public class MenuScene: SKScene {
    
    var startButton: ButtonNode!
    var gameLabel: SKLabelNode!
    var cameraNode: SKCameraNode!
        
    override public func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        
        setupAndAddCamera()
        registerPixelFont()
        setupAndAddStartButton()
        setupAndAddGameTitleLabel()
    }
    
    // Method to setup and add the camera
    func setupAndAddCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        cameraNode.position = CGPoint(x: 0, y: 0)
    }
    
    // Method to add the start button to the scene
    func setupAndAddStartButton() {
        startButton = ButtonNode(texture: SKTexture(imageNamed: "start-button"), size: CGSize(width: 184, height: 72))
        startButton.position = CGPoint(x: 0.0, y: 0.0)
        startButton.action = { (button) in
            if let scene = IntroCutScene(fileNamed: "IntroCutScene") {
                // Set the scale mode to scale to fit the window
                self.scene!.scaleMode = .aspectFill
                
                // Present the scene
                GameVariables.sceneView.presentScene(scene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2.5))
            }
        }
        self.addChild(startButton)
    }
    
    // Method to setup and add the title of the game
    func setupAndAddGameTitleLabel() {
        gameLabel = SKLabelNode(text: "Morning of the Keynote")
        gameLabel.fontName = "Minecraft"
        gameLabel.fontSize = 72.0
        gameLabel.position = CGPoint(x: 0.0, y: 200.0)
        gameLabel.fontColor = NSColor.black
        self.addChild(gameLabel)
    }
    
    // Method which registers the pixel font so other scenes can use it
    func registerPixelFont() {
        let font = Bundle.main.url(forResource: "Minecraft", withExtension: ".ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(font, CTFontManagerScope.process, nil)
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }

}


