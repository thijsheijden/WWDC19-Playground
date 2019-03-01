import PlaygroundSupport
import SpriteKit

public class GameScene: SKScene {

    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    
    override public func didMove(to view: SKView) {
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: 0))
        thePlayer.setupStateMachine()
        cameraNode = SKCameraNode()
        addChildNodesToView()
    }
    
    func addChildNodesToView() {
        self.addChild(thePlayer)
        self.addChild(cameraNode!)
        setupCamera()
    }
    
    func setupCamera() {
        camera = cameraNode
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {

        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override public func mouseDown(with event: NSEvent) {
    }
    
    override public func mouseDragged(with event: NSEvent) {
    }
    
    override public func mouseUp(with event: NSEvent) {
    }
    
    override public func update(_ currentTime: TimeInterval) {
        thePlayer.getMovementSpeed()
        updateCameraPosition()
    }
    
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    override public func keyDown(with event: NSEvent) {
        switch event.characters! {
        case let x where x == "a":
            print("a")
            thePlayer.left = true
            print(thePlayer.left)
        case let x where x == "d":
            thePlayer.right = true
            print(thePlayer.left)
        default:
            print("other key pressed")
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        switch event.characters! {
        case let x where x == "a":
            thePlayer.left = false
        case let x where x == "d":
            thePlayer.right = false
        default:
            print("other key pressed")
        }
    }
    
}


