import PlaygroundSupport
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {

    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    
    var bugNodeLocations: [CGPoint] = [CGPoint(x: 500, y: 80), CGPoint(x: -300, y: -150)]
    var bugNodes = [BugNode]()
    
    override public func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: 0))
        thePlayer.setupStateMachine()
        cameraNode = SKCameraNode()
        addChildNodesToView()
        setupBugNodes()
        setupAndAddDeveloperNode()
        
        
        self.view?.showsFPS = true
        self.view?.showsNodeCount = true
//        self.view?.showsPhysics = true
//        self.view?.showsFields = true
        
    }
    
    func addChildNodesToView() {
        self.addChild(thePlayer)
        self.addChild(cameraNode!)
        setupCamera()
    }
    
    func setupCamera() {
        camera = cameraNode
    }
    
    func setupBugNodes() {
        for i in 0...bugNodeLocations.count-1 {
            let bugNode = BugNode(texture: SKTexture(imageNamed: "chicken"), size: CGSize(width: 100, height: 100), bugData: BugDataStruct(image: GameVariables.bugImage[i], answerLabels: GameVariables.imageLabels[i], correctAnswer: GameVariables.correctAnswer[i]))
            bugNode.position = bugNodeLocations[i]
            bugNodes.append(bugNode)
            addBugNodesToView(bugNode: bugNode)
        }
    }
    
    func addBugNodesToView(bugNode: BugNode) {
        self.addChild(bugNode)
    }
    
    func setupAndAddDeveloperNode() {
        let developerNode = DeveloperNode(texture: SKTexture(imageNamed: "laptop"), size: CGSize(width: 100.0, height: 50.0))
        developerNode.position = CGPoint(x: 0.0, y: -150.0)
        self.addChild(developerNode)
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
        updateBugPositions()
    }
    
    func updateBugPositions() {
        for bug in bugNodes {
            bug.moveOnPlatform()
        }
    }
    
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    override public func keyDown(with event: NSEvent) {
        switch event.characters! {
        case let x where x == "a":
            print("a")
            thePlayer.left = true
        case let x where x == "d":
            thePlayer.right = true
        case let x where x == " ":
            thePlayer.jump = true
        default:
            print(event.characters!)
        }
    }
    
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
            thePlayer.currentlyTouchingGround = true
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.bug.rawValue {
            if let bugNode = contact.bodyB.node as? BugNode {
                bugNode.setMovementBoundaries(minX: (contact.bodyA.node?.frame.minX)!, maxX: (contact.bodyA.node?.frame.maxX)!)
            }
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.bug.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.developer.rawValue {
            if let bugNode = contact.bodyA.node as? BugNode {
                bugNode.removeFromParent()
                let popup = bugNode.createPopupNode()
                let centerFramePosition = CGPoint(x: Double(((self.cameraNode?.frame.minX)! + (self.cameraNode?.frame.maxX)!) / 2), y: Double(((self.cameraNode?.frame.minY)! + (self.cameraNode?.frame.maxY)!) / 2))
                popup.position = centerFramePosition
                self.addChild(popup)
            }
        }
    }
    
}


