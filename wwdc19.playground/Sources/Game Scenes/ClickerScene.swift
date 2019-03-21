import SpriteKit

class ClickerScene: SKScene {
    
    // All the variables and constants in this scene
    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    
    // Variables and constants
    var movementEnabled: Bool = true
    
    override func didMove(to view: SKView) {
        
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: -64))
        thePlayer.setupStateMachine()
        
        cameraNode = SKCameraNode()
        
        addChildNodesToView()
    }
    
    // Adding some of the created children to the scene
    func addChildNodesToView() {
        self.addChild(thePlayer)
        self.addChild(cameraNode!)
        setupCamera()
    }
    
    // Setting up the camera
    func setupCamera() {
        camera = cameraNode
        cameraNode?.setScale(1.5)
    }
    
    // Updating the camera node position to be centered on the player
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        if movementEnabled {
            thePlayer.getMovementSpeed()
            updateCameraPosition()
        }
    }
    
    // Registering key down events with their corresponding actions
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
    
    // Registering key up events with their corresponding actions
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
    
}
