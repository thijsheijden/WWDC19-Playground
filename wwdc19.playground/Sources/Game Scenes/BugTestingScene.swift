import PlaygroundSupport
import SpriteKit

public class BugTestingScene: SKScene, SKPhysicsContactDelegate {
    
    // Global Nodes
    var cameraNode: SKCameraNode?
    var thePlayer: PlayerNode = PlayerNode()
    var drawingCanvas: NSView?
    
    // Did move to this scene event
    override public func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        setupCamera()
        setupPlayer()
        setupAndAddCanvasView()
    }
    
    // Setting up the player node
    func setupPlayer() {
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: -800.0, y: -64))
        thePlayer.setupStateMachine()
        self.addChild(thePlayer)
    }
    
    // Setting up the camera node
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
    // Adding an NSView which will be used as a drawing canvas
    func setupAndAddCanvasView() {
        let canvas = NSView(frame: NSRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
        canvas.layer?.backgroundColor = CGColor.black
        self.view?.addSubview(canvas, positioned: .above, relativeTo: nil)
    }
    
    // Called before every frame update
    override public func update(_ currentTime: TimeInterval) {
        thePlayer.getMovementSpeed()
        updateCameraPosition()
    }
    
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    // All key down events
    override public func keyDown(with event: NSEvent) {
        switch event.characters! {
        case let x where x == "a":
            thePlayer.left = true
        case let x where x == "d":
            thePlayer.right = true
        case let x where x == " ":
            thePlayer.jump = true
        default:
            print(event.characters!)
        }
    }
    
    // All key up events
    public override func keyUp(with event: NSEvent) {
        switch event.characters! {
        case let x where x == "a":
            thePlayer.left = false
        case let x where x == "d":
            thePlayer.right = false
        case let x where x == " ":
            thePlayer.jump = false
        default:
            print("other key pressed")
        }
    }
    
    // When a collision is detected in the scene
    public func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.player.rawValue {
            if playerTouchingTopOfPlatform(frame: (contact.bodyA.node?.frame)!) {
                thePlayer.currentlyTouchingGround = true
            }
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.player.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.nextLevelDoor.rawValue {
        }
    }
    
    // Method which calculates wether the player touched the top of the platform or not
    func playerTouchingTopOfPlatform(frame: CGRect) -> Bool {
        return (thePlayer.frame.minY - 2.50) < frame.maxY
    }
    
}


