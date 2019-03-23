import SpriteKit

public class ClickerScene: SKScene, SKPhysicsContactDelegate {
    
    // All the variables and constants in this scene
    var thePlayer: PlayerNode = PlayerNode()
    var cameraNode: SKCameraNode?
    var mrClicker: MrClickerNode?
    var tutorialPopup: SceneCompletionNode?
    var dimPanel: SKSpriteNode?
        
    // Variables and constants
    var movementEnabled: Bool = true
    var currentlyTouchingGround: Bool = true
    
    override public func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: 0, y: -64))
        thePlayer.zPosition = 0
        thePlayer.setupStateMachine()
        
        cameraNode = SKCameraNode()
        
        addChildNodesToView()
        setupAndAddMrClicker()
        addTutorialPopup()
        addGlow()
        startTimer()
    }
    
    // Method for adding the explanation popup
    func addTutorialPopup() {
        tutorialPopup = SceneCompletionNode(size: CGSize(width: 600, height: 500), completionLabel: "This is it. The final stage. Catch Mr. Clicker, there is no keynote without him.\n\nI think he is hiding in one of these tubes here.\n\n Try and click on him. You have just 30 seconds before the keynote starts! So hurry!")
        tutorialPopup?.position = CGPoint(x: 0, y: 0)
        tutorialPopup?.zPosition = 101
        tutorialPopup?.textLineNodeLabel?.fontSize = 32
        tutorialPopup?.textLineNodeLabel?.horizontalAlignmentMode = .center
        tutorialPopup?.textLineNodeLabel?.position = CGPoint(x: 5, y: -110)
        tutorialPopup?.textLineNodeLabel?.preferredMaxLayoutWidth = 585
        tutorialPopup?.continueButton?.action = { (button) in
            self.tutorialPopup?.removeFromParent()
            self.dimPanel?.removeFromParent()
            self.mrClicker?.startMovingMrClicker()
        }
        addDimPanelBehindPopup()
        self.addChild(tutorialPopup!)
    }
    
    // Method for adding a dimpanel
    func addDimPanelBehindPopup() {
        dimPanel = SKSpriteNode(color: NSColor.black, size: CGSize(width: self.size.width * 1.5, height: self.size.height * 1.5))
        dimPanel?.alpha = 0.0
        dimPanel?.zPosition = 100
        dimPanel?.alpha = 0.75
        dimPanel?.position = (self.cameraNode?.position)!
        self.addChild(dimPanel!)
    }
    
    // Setting up mr clicker node
    func setupAndAddMrClicker() {
        mrClicker = MrClickerNode(texture: SKTexture(imageNamed: "mr-clicker"), size: CGSize(width: 112, height: 240))
        mrClicker?.position = CGPoint(x: -400, y: -220)
        self.addChild(mrClicker!)
    }
    
    // Method which adds nice glow to the keynote sign
    func addGlow() {
        for node in self.children {
            if node.name == "keynote-sign" {
                if let spriteNode = node as? SKSpriteNode {
                    spriteNode.addGlow()
                }
            }
        }
    }
    
    // Adding some of the created children to the scene
    func addChildNodesToView() {
        self.addChild(thePlayer)
        self.addChild(cameraNode!)
        setupCamera()
    }
    
    // Method to start the 30 second timer in which you have to catch mr clicker
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { (timer) in
            self.timeUpPopup()
        }
    }
    
    // Method to display that the time is up but that you luckily have a backup clicker
    func timeUpPopup() {
        let timeUpPopup = SceneCompletionNode(size: CGSize(width: 600, height: 500), completionLabel: "Well, it seems like Mr. Clicker has gotten away this time.\n\nLuckily we have a backup clicker. Get out there Tim!")
        timeUpPopup.position = CGPoint(x: 0, y: 0)
        timeUpPopup.zPosition = 101
        timeUpPopup.textLineNodeLabel?.fontSize = 32
        timeUpPopup.textLineNodeLabel?.horizontalAlignmentMode = .center
        timeUpPopup.textLineNodeLabel?.position = CGPoint(x: 5, y: -110)
        timeUpPopup.textLineNodeLabel?.preferredMaxLayoutWidth = 585
        timeUpPopup.continueButton?.action = { (button) in
            // TODO: Move to the final scene with WWDC19 on it or something akin
        }
        addDimPanelBehindPopup()
        self.addChild(timeUpPopup)
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
    
    override public func update(_ currentTime: TimeInterval) {
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
    override public func keyUp(with event: NSEvent) {
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
    
    public func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.player.rawValue {
            if playerTouchingTopOfPlatform(frame: (contact.bodyA.node?.frame)!) {
                thePlayer.currentlyTouchingGround = true
            }
        }
    }
    
    // Method which calculates wether the player touched the top of the platform or not
    func playerTouchingTopOfPlatform(frame: CGRect) -> Bool {
        return (thePlayer.frame.minY - 2.50) < frame.maxY
    }
    
}
