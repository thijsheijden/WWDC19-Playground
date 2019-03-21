import PlaygroundSupport
import SpriteKit
import AVFoundation

public class BugHuntingScene: SKScene, SKPhysicsContactDelegate {

    // All the variables and constants in this scene
    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    var dimPanel: SKSpriteNode?
    var bugsFixedLabel: SKLabelNode?
    var textLineNode: TextLineNode?
    var zoomOutButton: ButtonNode?
    var selfiePanel: SKSpriteNode?
    var timerNode: TimerNode?
    
    var audioPlayer: AVAudioPlayer?
    
    var movementEnabled: Bool = false
    
    var numberOfBugsFixed: Int = 0
    var capturedBugNode: BugNode?
    
    var zoomedOut: Bool = false
    var canPressZoomButton: Bool = true
    
    var bugNodeLocations: [CGPoint] = [CGPoint(x: 2960, y: 960), CGPoint(x: 37, y: 308), CGPoint(x: 1970, y: 730)]
    var bugNodes = [BugNode]()
    
    var developerNodesLocations: [CGPoint] = [CGPoint(x: 900, y: 285.0), CGPoint(x: 1090.0, y: 628), CGPoint(x: 2800, y: 475)]
    
    var jumpPadNodeLocations: [CGPoint] = [CGPoint(x: -670.0, y: -125.0), CGPoint(x: 2190.0, y: -125.0), CGPoint(x: 2480, y: 353)]
    
    var canCurrentlyCollideWithBugNode: Bool = true
    
    var scholarNodes: [ScholarNode] = [ScholarNode]()
    var scholarNodeLocations: [CGPoint] = [CGPoint(x: 350.0, y: -170.0), CGPoint(x: 1545, y: 715), CGPoint(x: 2400, y: -85), CGPoint(x: 3015, y: 400)]
    
    var canTakeSelfie: Bool = true
    
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
        setupAndAddZoomOutButton()
        setupScholarNodes()
        setupAndAddTimerNode()
        runTinyTutorial { () -> Void in
            self.removeMovementButtons()
            self.movementEnabled = true
        }
        
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
    
    // Method which runs the short tutorial at the start of the game.
    func runTinyTutorial(completion: @escaping () -> Void) {
        let introTextBubble = TextLineNode(texture: SKTexture(imageNamed: "text-bubble"), size: CGSize(width: 450, height: 150))
        introTextBubble.position = CGPoint(x: 225, y: 110)
        introTextBubble.textLineNodeLabel?.fontSize = 30.0
        self.cameraNode?.addChild(introTextBubble)
        introTextBubble.startTypingText(text: GameVariables.gameSceneText, timeBetweenChars: 0.1, removeOnCompletion: true) { () -> Void in
            self.timerNode?.startTimer()
            completion()
        }
        moveBugToDeveloperTutorial()
    }
    
    // Method to remove all the tutorial movement keys
    func removeMovementButtons() {
        for node in self.children {
            if node.name == "movementKeys" {
                node.removeFromParent()
            }
        }
    }
    
    // Moving a bug to a developer for the tutorial
    func moveBugToDeveloperTutorial() {
        let bug = BugNode(texture: SKTexture(imageNamed: "bug-1"), size: CGSize(width: 100, height: 100), bugData: BugDataStruct(imageName: GameVariables.bugImage[0], answerLabels: GameVariables.imageLabels[0], correctAnswer: GameVariables.correctAnswer[0]))
        bug.position = CGPoint(x: 110, y: -50)
        bug.isHidden = true
        bug.isUserInteractionEnabled = false
        bug.physicsBody = nil
        self.addChild(bug)
        
        // Setting up the cursor node that follows the bug to imitate dragging
        let cursorNode = SKSpriteNode(texture: SKTexture(imageNamed: "cursor"), color: NSColor.white, size: CGSize(width: 80, height: 85))
        cursorNode.position = CGPoint(x: 110, y: -120)
        cursorNode.isHidden = true
        self.addChild(cursorNode)
        
        bug.run(SKAction.sequence([SKAction.changeCharge(by: 0.0, duration: 1.5), SKAction.unhide(), SKAction.move(to: CGPoint(x: 500, y: 28), duration: 1.5), SKAction.move(to: CGPoint(x: 530, y: 235), duration: 1.5), SKAction.move(to: CGPoint(x: 750, y: 210), duration: 1.5)])) { () -> Void in
                bug.removeFromParent()
        }
        
        cursorNode.run(SKAction.sequence([SKAction.changeCharge(by: 0.0, duration: 1.5), SKAction.unhide(), SKAction.move(to: CGPoint(x: 500, y: -42), duration: 1.5), SKAction.move(to: CGPoint(x: 530, y: 165), duration: 1.5), SKAction.move(to: CGPoint(x: 750, y: 140), duration: 1.5)])) { () -> Void in
            cursorNode.removeFromParent()
        }
    }
    
    // Setting up the camera
    func setupCamera() {
        camera = cameraNode
        cameraNode?.setScale(1.5)
    }
    
    // Setting up all the bugnodes with their corresponding locations in the scene
    func setupBugNodes() {
        for i in 0...bugNodeLocations.count-1 {
            let bugNode = BugNode(texture: SKTexture(imageNamed: "bug-1"), size: CGSize(width: 100, height: 100), bugData: BugDataStruct(imageName: GameVariables.bugImage[i], answerLabels: GameVariables.imageLabels[i], correctAnswer: GameVariables.correctAnswer[i]))
            bugNode.zPosition = -1
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
        bugsFixedLabel = SKLabelNode(text: "0/3 bugs fixed")
        bugsFixedLabel?.fontName = "Minecraft"
        bugsFixedLabel?.fontSize = 25.0
        bugsFixedLabel?.position = CGPoint(x: -500, y: 250)
        bugsFixedLabel?.zPosition = 99
        self.cameraNode?.addChild(bugsFixedLabel!)
    }
    
    // Method which sets up all the scholar nodes
    func setupScholarNodes() {
        for scholarNodeLocation in scholarNodeLocations {
            let scholarNode = ScholarNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 50.0, height: 150.0))
            scholarNode.position = scholarNodeLocation
            scholarNodes.append(scholarNode)
            self.addChild(scholarNode)
        }
    }
    
    // Method which loops through all the scholar nodes and updates their positions, based on the players location
    func updateScholarNodeLocations() {
        for scholar in scholarNodes {
            scholar.checkWhereTimIs(timPosition: thePlayer.position)
        }
    }
    
    // Setting up and adding the door which takes the player to the next level
    func setupAndAddNextLevelDoorNode() {
        let nextLevelDoorNode = DoorNode(texture: SKTexture(imageNamed: "apple"), size: CGSize(width: 100.0, height: 100.0))
        nextLevelDoorNode.position = CGPoint(x: 3000.0, y: 50.0)
        self.addChild(nextLevelDoorNode)
    }
    
    // Setting up and adding the developer nodes to the scene at set locations
    func setupAndAddDeveloperNode() {
        for developerNodeLocation in developerNodesLocations {
            let developerNode = DeveloperNode(texture: SKTexture(imageNamed: "developer-idle"), size: CGSize(width: 300.0, height: 300.0))
            developerNode.position = developerNodeLocation
            self.addChild(developerNode)
        }
    }
    
    // Setting up the jumppad nodes and adding them to the scene
    func setupJumpPads() {
        for position in jumpPadNodeLocations {
            let jumpPad = JumpPadNode(texture: SKTexture(imageNamed: "jumppad-idle"), size: CGSize(width: 128.0, height: 128.0))
            jumpPad.position = position
            self.addChild(jumpPad)
        }
    }
    
    // MARK: Camera zoom button and functionality
    // Setting up the zoom out button and adding it to the bottom right of the camera node frame
    func setupAndAddZoomOutButton() {
        zoomOutButton = ButtonNode(texture: SKTexture(imageNamed: "zoom-camera-out"), size: CGSize(width: 100.0, height: 100.0))
        zoomOutButton?.position = CGPoint(x: 525.0, y: -225.0)
        zoomOutButton?.zPosition = 99
        
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
        zoomOutButton?.texture = SKTexture(imageNamed: "zoom-camera-in")
        cameraNode?.run(SKAction.scale(to: 2.0, duration: 1.0)) { () -> Void in
            GameVariables.zoomMultiplication = 2.0
            self.zoomedOut = true
            self.canPressZoomButton = true
        }
    }
    
    // Zoom in the camera functionality
    func zoomInCamera(completion: @escaping () -> Void) {
        canPressZoomButton = false
        zoomOutButton?.texture = SKTexture(imageNamed: "zoom-camera-out")
        cameraNode?.run(SKAction.scale(to: 1.5, duration: 1.0)) { () -> Void in
            GameVariables.zoomMultiplication = 1.5
            self.zoomedOut = false
            self.canPressZoomButton = true
            completion()
        }
    }
    
    // Setting up and adding the timer to the camera frame
    func setupAndAddTimerNode() {
        timerNode = TimerNode(texture: SKTexture(imageNamed: "timer1"), size: CGSize(width: 100.0, height: 100.0))
        timerNode?.position = CGPoint(x: -500.0, y: 175.0)
        timerNode?.zPosition = 99
        self.cameraNode?.addChild(timerNode!)
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
            updateScholarNodeLocations()
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
            if numberOfBugsFixed == 3 {
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
                    developerNode.setDeveloperToBusy()
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
                    // Making sure the bugs never get stuck
                    if (contact.bodyB.node?.frame.minX)! < (contact.bodyA.node?.frame.minX)! {
                        contact.bodyA.node?.physicsBody?.applyImpulse(CGVector(dx: 25.0, dy: 25.0))
                    } else {
                        contact.bodyA.node?.physicsBody?.applyImpulse(CGVector(dx: -25.0, dy: 25.0))
                    }
                }
            }
        }
        
        // Detecting collision between scholar node and player node
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.player.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.scholar.rawValue {
            if canTakeSelfie {
                canTakeSelfie = false
                movementEnabled = false
                contact.bodyB.node?.removeFromParent()
                takeSelfie()
            }
        }
        
        // Detecting collision between a scholar and a platform
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.scholar.rawValue {
            if let scholarNode = contact.bodyB.node as? ScholarNode {
                scholarNode.setMovementBoundaries(minX: (contact.bodyA.node?.frame.minX)!, maxX: (contact.bodyA.node?.frame.maxX)!)
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
        return ((thePlayer.frame.minY - 2.50) < frame.maxY) && ((thePlayer.frame.minX > frame.minX) && (thePlayer.frame.maxX < frame.maxX))
    }
    
    // Method which adds a dark background behind the popup.
    func addDimPanelBehindPopup() {
        dimPanel = SKSpriteNode(color: NSColor.black, size: CGSize(width: self.size.width * 1.5, height: self.size.height * 1.5))
        dimPanel!.alpha = 0.0
        dimPanel!.zPosition = 100
        dimPanel!.position = (self.cameraNode?.position)!
        dimPanel!.run(SKAction.fadeAlpha(to: 0.75, duration: 1.0))
        self.addChild(dimPanel!)
    }
    
    // Method which imitates taking a selfie, by making the screen bright white and playing the camera shutter sound
    func takeSelfie() {
        selfiePanel = SKSpriteNode(color: NSColor.white, size: CGSize(width: self.size.width + 1500, height: self.size.height + 1500))
        selfiePanel!.alpha = 0.0
        selfiePanel!.zPosition = 100
        selfiePanel!.position = CGPoint(x: Double(((self.cameraNode?.frame.minX)! + (self.cameraNode?.frame.maxX)!) / 2), y: Double(((self.cameraNode?.frame.minY)! + (self.cameraNode?.frame.maxY)!) / 2))
        self.addChild(selfiePanel!)
        selfiePanel!.run(SKAction.sequence([SKAction.fadeAlpha(to: 1.0, duration: 0.4), SKAction.fadeAlpha(to: 0.0, duration: 0.6)])) { () -> Void in
            self.movementEnabled = true
            self.removeFromParent()
            self.canTakeSelfie = true
        }
        do {
            let cameraSoundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "cameraSoundEffect", ofType: "mp3")!)
            audioPlayer = try AVAudioPlayer(contentsOf: cameraSoundEffect)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
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
        bugsFixedLabel?.text = "\(numberOfBugsFixed)/3 bugs fixed"
    }
}


