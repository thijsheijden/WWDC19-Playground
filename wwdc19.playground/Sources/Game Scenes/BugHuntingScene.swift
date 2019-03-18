import PlaygroundSupport
import SpriteKit

public class BugHuntingScene: SKScene, SKPhysicsContactDelegate {

    // All the variables and constants in this scene
    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    var dimPanel: SKSpriteNode?
    var bugsFixedLabel: SKLabelNode?
    var textLineNode: TextLineNode?
    var zoomOutButton: ButtonNode?
    
    var movementEnabled: Bool = true
    
    var numberOfBugsFixed: Int = 0
    var capturedBugNode: BugNode?
    
    var zoomedOut: Bool = false
    var canPressZoomButton: Bool = true
    
    var bugNodeLocations: [CGPoint] = [CGPoint(x: 883, y: 229), CGPoint(x: 37, y: 308), CGPoint(x: 1970, y: 730)]
    var bugNodes = [BugNode]()
    
    var developerNodesLocations: [CGPoint] = [CGPoint(x: 100, y: -150.0), CGPoint(x: 995, y: 520), CGPoint(x: 2890, y: 420)]
    
    var jumpPadNodeLocations: [CGPoint] = [CGPoint(x: -670.0, y: -125.0), CGPoint(x: 2190.0, y: -125.0)]
    
    var canCurrentlyCollideWithBugNode: Bool = true
    
    // Moved to this scene
    override public func didMove(to view: SKView) {
        
        // Conforming to this delegate to receive colision information
        physicsWorld.contactDelegate = self
        
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: -64))
        thePlayer.setupStateMachine()
        cameraNode = SKCameraNode()
        addChildNodesToView()
        setupBugNodes()
        setupAndAddDeveloperNode()
        setupAndAddBugsFixedLabel()
        setupAndAddNextLevelDoorNode()
        setupJumpPads()
        setupTextLineNode()
        setupAndAddZoomOutButton()
        
        self.view?.showsFPS = true
        self.view?.showsNodeCount = true
//        self.view?.showsPhysics = true
//        self.view?.showsFields = true
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
    }
    
    // Setting up all the bugnodes with their corresponding locations in the scene
    func setupBugNodes() {
        for i in 0...bugNodeLocations.count-1 {
            let bugNode = BugNode(texture: SKTexture(imageNamed: "bug-1"), size: CGSize(width: 100, height: 100), bugData: BugDataStruct(imageName: GameVariables.bugImage[i], answerLabels: GameVariables.imageLabels[i], correctAnswer: GameVariables.correctAnswer[i]))
            bugNode.position = bugNodeLocations[i]
            bugNodes.append(bugNode)
            addBugNodesToView(bugNode: bugNode)
        }
    }
    
    // Adding those bug nodes to the scene one by one
    func addBugNodesToView(bugNode: BugNode) {
        self.addChild(bugNode)
    }
    
    // Setting up the label which displays how many bugs you have fixed, shown top right of the camera frame
    func setupAndAddBugsFixedLabel() {
        bugsFixedLabel = SKLabelNode(text: "0/6 bugs fixed")
        bugsFixedLabel?.fontName = "Minecraft"
        bugsFixedLabel?.fontSize = 20.0
        bugsFixedLabel?.position = CGPoint(x: -500, y: 250)
        self.cameraNode?.addChild(bugsFixedLabel!)
    }
    
    // Setting up and adding the door which takes the player to the next level
    func setupAndAddNextLevelDoorNode() {
        let nextLevelDoorNode = DoorNode(texture: SKTexture(imageNamed: "apple"), size: CGSize(width: 100.0, height: 100.0))
        nextLevelDoorNode.position = CGPoint(x: 300.0, y: 50.0)
        self.addChild(nextLevelDoorNode)
    }
    
    // Setting up and adding the developer nodes to the scene at set locations
    func setupAndAddDeveloperNode() {
        for developerNodeLocation in developerNodesLocations {
            let developerNode = DeveloperNode(texture: SKTexture(imageNamed: "laptop"), size: CGSize(width: 100.0, height: 70.0))
            developerNode.position = developerNodeLocation
            self.addChild(developerNode)
        }
    }
    
    // Setting up the jumppad nodes and adding them to the scene
    func setupJumpPads() {
        for position in jumpPadNodeLocations {
            let jumpPad = JumpPadNode(texture: SKTexture(imageNamed: "chicken"), size: CGSize(width: 100.0, height: 50.0))
            jumpPad.position = position
            self.addChild(jumpPad)
        }
    }
    
    // Setting up the node which displays in the bottom of the screen and just shows some text
    func setupTextLineNode() {
        textLineNode = TextLineNode(texture: SKTexture(imageNamed: "platform-1"), size: CGSize(width: 500.0, height: 100.0))
        textLineNode?.position = CGPoint(x: 310.0, y: 125.0)
        textLineNode?.zPosition = 100
        self.cameraNode?.addChild(textLineNode!)
        textLineNode?.startTypingText(text: GameVariables.gameSceneText)
    }
    
    // MARK: Camera zoom button and functionality
    // Setting up the zoom out button and adding it to the bottom right of the camera node frame
    func setupAndAddZoomOutButton() {
        zoomOutButton = ButtonNode(texture: SKTexture(imageNamed: "chicken"), size: CGSize(width: 100.0, height: 100.0))
        zoomOutButton?.position = CGPoint(x: 250.0, y: -250.0)
        
        // Setting the action for when the user taps the button depending on the zoom state of the level
        zoomOutButton?.action = { (button) in
            switch (self.zoomedOut, self.canPressZoomButton) {
            case (true, true):
                self.zoomInCamera() { () -> Void in }
            case (false, true):
                self.zoomOutCamera()
            default:
                print("")
            }
        }
        
        self.cameraNode?.addChild(zoomOutButton!)
    }
    
    // Zoom out the camera functionality
    func zoomOutCamera() {
        canPressZoomButton = false
        cameraNode?.run(SKAction.scale(to: 1.5, duration: 1.0)) { () -> Void in
            GameVariables.zoomMultiplication = 1.5
            self.zoomedOut = true
            self.canPressZoomButton = true
        }
    }
    
    // Zoom in the camera functionality
    func zoomInCamera(completion: @escaping () -> Void) {
        canPressZoomButton = false
        cameraNode?.run(SKAction.scale(to: 1.0, duration: 1.0)) { () -> Void in
            GameVariables.zoomMultiplication = 1.0
            self.zoomedOut = false
            self.canPressZoomButton = true
            completion()
        }
    }
    
    @objc static override public var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    // Method which gets called every 1/60th of a second to update for the next frame
    override public func update(_ currentTime: TimeInterval) {
        if movementEnabled {
            thePlayer.getMovementSpeed()
            updateCameraPosition()
            updateBugPositions()
        }
    }
    
    // Updating the positions of the bugs every frame update
    func updateBugPositions() {
        for bug in bugNodes {
            bug.moveOnPlatform()
        }
    }
    
    // Updating the camera node position to be centered on the player
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
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
    
    // When a collision is detected in the scene
    public func didBegin(_ contact: SKPhysicsContact) {
        // Collision between platform and player
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.player.rawValue {
            if playerTouchingTopOfPlatform(frame: (contact.bodyA.node?.frame)!) {
                thePlayer.currentlyTouchingGround = true
            }
        }
        
        // When a colision is detected between a platform and a bug, the bug receives the maxX and minX values for that platform so it never falls of
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
        
        // Colision between player and next level door
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.player.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.nextLevelDoor.rawValue {
            print((bugsFixedLabel?.text)!)
            if (bugsFixedLabel?.text)! == "3/6 bugs fixed" {
                if let nextScene = BugTestingScene(fileNamed: "BugTestingScene") {
                    GameVariables.sceneView.presentScene(nextScene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 2.5))
                }
            }
        }
        
        // Colision between bug and developer nodes. Popup with question gets displayed
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.bug.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.developer.rawValue && canCurrentlyCollideWithBugNode {
            
            if let developerNode = contact.bodyB.node as? DeveloperNode {
                if !developerNode.isBusy {
                    canCurrentlyCollideWithBugNode = false
                    movementEnabled = false
                    developerNode.isBusy = true
                    if let bugNode = contact.bodyA.node as? BugNode {
                        bugNode.removeFromParent()
                        
                        // Check wether zoomed in, if so zoom out
                        if zoomedOut {
                            self.zoomInCamera() { () -> Void in
                                self.addBugNodePopup(bugNode: bugNode)
                            }
                        } else {
                            addBugNodePopup(bugNode: bugNode)
                        }
                    }
                } else {
                    print("Sorry this developer is busy")
                }
            }
        }
    }
    
    func addBugNodePopup(bugNode: BugNode) {
        let popup = bugNode.createPopupNode()
        let centerFramePosition = CGPoint(x: Double(((self.cameraNode?.frame.minX)! + (self.cameraNode?.frame.maxX)!) / 2), y: Double(((self.cameraNode?.frame.minY)! + (self.cameraNode?.frame.maxY)!) / 2))
        popup.position = centerFramePosition
        popup.delegate = self
        addDimPanelBehindPopup()
        popup.run(SKAction.fadeIn(withDuration: 1.0))
        self.addChild(popup)
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
        dimPanel!.position = (self.cameraNode?.position)!
        dimPanel!.run(SKAction.fadeAlpha(to: 0.75, duration: 1.0))
        self.addChild(dimPanel!)
    }
}

// Conforming to the delegate for the bug popup so we know when a user has selected the correct answer
extension BugHuntingScene: BugPopupCorrectAnswerDelegate {
    func answeredCorrectly() {
        canCurrentlyCollideWithBugNode = true
        movementEnabled = true
        numberOfBugsFixed += 1
        updateNumberOfBugsFixedLabel()
        dimPanel!.run(SKAction.fadeAlpha(to: 0.0, duration: 1.0))
        dimPanel?.removeFromParent()
    }
    
    // Updating the label to display the correct number of bugs the player has fixed
    func updateNumberOfBugsFixedLabel() {
        bugsFixedLabel?.run(SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.2), SKAction.scale(by: 0.8, duration: 0.2)]))
        bugsFixedLabel?.text = "\(numberOfBugsFixed)/6 bugs fixed"
    }
}

