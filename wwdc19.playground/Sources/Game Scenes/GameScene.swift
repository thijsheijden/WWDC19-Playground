import PlaygroundSupport
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {

    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    var dimPanel: SKSpriteNode?
    var bugsFixedLabel: SKLabelNode?
    
    var movementEnabled: Bool = true
    
    var numberOfBugsFixed: Int = 0
    
    var bugNodeLocations: [CGPoint] = [CGPoint(x: 883, y: 229), CGPoint(x: 37, y: 308), CGPoint(x: 1970, y: 730)]
    var bugNodes = [BugNode]()
    
    var developerNodesLocations: [CGPoint] = [CGPoint(x: 100, y: -150.0), CGPoint(x: 995, y: 520), CGPoint(x: 2890, y: 420)]
    
    var jumpPadNodeLocations: [CGPoint] = [CGPoint(x: -670.0, y: -125.0), CGPoint(x: 2190.0, y: -125.0)]
    
    var canCurrentlyCollideWithBugNode: Bool = true
    
    override public func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: 0))
        thePlayer.setupStateMachine()
        cameraNode = SKCameraNode()
        addChildNodesToView()
        setupBugNodes()
        setupAndAddDeveloperNode()
        setupAndAddBugsFixedLabel()
        setupAndAddNextLevelDoorNode()
        setupJumpPads()
        
        
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
            let bugNode = BugNode(texture: SKTexture(imageNamed: "bug-1"), size: CGSize(width: 100, height: 100), bugData: BugDataStruct(imageName: GameVariables.bugImage[i], answerLabels: GameVariables.imageLabels[i], correctAnswer: GameVariables.correctAnswer[i]))
            bugNode.position = bugNodeLocations[i]
            bugNodes.append(bugNode)
            addBugNodesToView(bugNode: bugNode)
        }
    }
    
    func addBugNodesToView(bugNode: BugNode) {
        self.addChild(bugNode)
    }
    
    func setupAndAddBugsFixedLabel() {
        bugsFixedLabel = SKLabelNode(text: "0/6 bugs fixed")
        bugsFixedLabel?.fontSize = 20.0
        bugsFixedLabel?.position = CGPoint(x: -500, y: 250)
        self.cameraNode?.addChild(bugsFixedLabel!)
    }
    
    func setupAndAddNextLevelDoorNode() {
        let nextLevelDoorNode = DoorNode(texture: SKTexture(imageNamed: "apple"), size: CGSize(width: 100.0, height: 100.0))
        nextLevelDoorNode.position = CGPoint(x: 300.0, y: 50.0)
        self.addChild(nextLevelDoorNode)
    }
    
    func setupAndAddDeveloperNode() {
        for developerNodeLocation in developerNodesLocations {
            let developerNode = DeveloperNode(texture: SKTexture(imageNamed: "laptop"), size: CGSize(width: 100.0, height: 70.0))
            developerNode.position = developerNodeLocation
            self.addChild(developerNode)
        }
    }
    
    func setupJumpPads() {
        for position in jumpPadNodeLocations {
            let jumpPad = JumpPadNode(texture: SKTexture(imageNamed: "chicken"), size: CGSize(width: 100.0, height: 50.0))
            jumpPad.position = position
            self.addChild(jumpPad)
        }
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
        if movementEnabled {
            thePlayer.getMovementSpeed()
            updateCameraPosition()
            updateBugPositions()
        }
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
        // Collision between platform and player
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.player.rawValue {
            if playerTouchingTopOfPlatform(frame: (contact.bodyA.node?.frame)!) {
                thePlayer.currentlyTouchingGround = true
            }
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.bug.rawValue {
            if let bugNode = contact.bodyB.node as? BugNode {
                bugNode.setMovementBoundaries(minX: (contact.bodyA.node?.frame.minX)!, maxX: (contact.bodyA.node?.frame.maxX)!)
            }
        }
        
        // Collision between player and ladder
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.player.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.jumpPad.rawValue {
            if let jumpPad = contact.bodyB.node as? JumpPadNode {
                if jumpPad.active {
                    jumpPad.activated()
                    thePlayer.jumpPadTouched()
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.player.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.nextLevelDoor.rawValue {
            print((bugsFixedLabel?.text)!)
            if (bugsFixedLabel?.text)! == "1/6 bugs fixed" {
                if let nextScene = BugTestingScene(fileNamed: "BugTestingScene") {
                    GameVariables.sceneView.presentScene(nextScene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 2.5))
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.bug.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.developer.rawValue && canCurrentlyCollideWithBugNode {
            
            if let developerNode = contact.bodyB.node as? DeveloperNode {
                if !developerNode.isBusy {
                    canCurrentlyCollideWithBugNode = false
                    movementEnabled = false
                    developerNode.isBusy = true
                    if let bugNode = contact.bodyA.node as? BugNode {
                        bugNode.removeFromParent()
                        let popup = bugNode.createPopupNode()
                        let centerFramePosition = CGPoint(x: Double(((self.cameraNode?.frame.minX)! + (self.cameraNode?.frame.maxX)!) / 2), y: Double(((self.cameraNode?.frame.minY)! + (self.cameraNode?.frame.maxY)!) / 2))
                        popup.position = centerFramePosition
                        popup.delegate = self
                        addDimPanelBehindPopup()
                        popup.run(SKAction.fadeIn(withDuration: 1.0))
                        self.addChild(popup)
                    }
                } else {
                    print("Sorry this developer is busy")
                }
            }
        }
    }
    
    // Method which calculates wether the player touched the top of the platform or not
    func playerTouchingTopOfPlatform(frame: CGRect) -> Bool {
        return (thePlayer.frame.minY - 2.50) < frame.maxY
    }
    
    // Method which adds a dark background behind the popup.
    func addDimPanelBehindPopup() {
        dimPanel = SKSpriteNode(color: NSColor.black, size: self.size)
        dimPanel!.alpha = 0.0
        dimPanel!.zPosition = 100
        dimPanel!.position = CGPoint(x: Double(((self.cameraNode?.frame.minX)! + (self.cameraNode?.frame.maxX)!) / 2), y: Double(((self.cameraNode?.frame.minY)! + (self.cameraNode?.frame.maxY)!) / 2))
        dimPanel!.run(SKAction.fadeAlpha(to: 0.75, duration: 1.0))
        self.addChild(dimPanel!)
    }
    
}

// Conforming to the delegate for the bug popup so we know when a user has selected the correct answer
extension GameScene: BugPopupCorrectAnswerDelegate {
    func answeredCorrectly() {
        canCurrentlyCollideWithBugNode = true
        movementEnabled = true
        numberOfBugsFixed += 1
        updateNumberOfBugsFixedLabel()
        dimPanel!.run(SKAction.fadeAlpha(to: 0.0, duration: 1.0))
        dimPanel?.removeFromParent()
    }
    
    func updateNumberOfBugsFixedLabel() {
        bugsFixedLabel?.text = "\(numberOfBugsFixed)/6 bugs fixed"
    }
}


