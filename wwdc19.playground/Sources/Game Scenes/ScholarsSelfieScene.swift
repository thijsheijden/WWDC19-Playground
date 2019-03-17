import PlaygroundSupport
import SpriteKit
import AVFoundation

public class ScholarsSelfieScene: SKScene, SKPhysicsContactDelegate {
    
    var movementEnabled: Bool = true
    var canTakeSelfie: Bool = true
    
    var cameraNode: SKCameraNode?
    var thePlayer: PlayerNode = PlayerNode()
    var drawingCanvas: NSView?
    var selfiePanel: SKSpriteNode?
    
    var audioPlayer: AVAudioPlayer?
    
    var scholarNodes: [ScholarNode] = [ScholarNode]()
    var scholarNodeLocations: [CGPoint] = [CGPoint(x: 100.0, y: 100.0), CGPoint(x: 150.0, y: 100.0), CGPoint(x: 100.0, y: -170.0), CGPoint(x: 160.0, y: -170.0), CGPoint(x: 220.0, y: -170.0), CGPoint(x: 300.0, y: -170.0)]
    
    override public func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        setupCamera()
        setupPlayer()
        setupScholarNodes()
        
        self.view?.showsNodeCount = true
    }
    
    func setupPlayer() {
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: -100.0, y: 0))
        thePlayer.setupStateMachine()
        self.addChild(thePlayer)
    }
    
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
        cameraNode?.setScale(1.5)
    }
    
    // Method which sets up all the scholar nodes
    func setupScholarNodes() {
        for scholarNodeLocation in scholarNodeLocations {
            let scholarNode = ScholarNode(texture: SKTexture(imageNamed: "chicken"), size: CGSize(width: 100.0, height: 50.0))
            scholarNode.position = scholarNodeLocation
            scholarNodes.append(scholarNode)
            self.addChild(scholarNode)
        }
    }
    
    override public func update(_ currentTime: TimeInterval) {
        if movementEnabled {
            thePlayer.getMovementSpeed()
            updateScholarNodeLocations()
        }
        updateCameraPosition()
    }
    
    // Method which loops through all the scholar nodes and updates their positions, based on the players location
    func updateScholarNodeLocations() {
        for scholar in scholarNodes {
            scholar.checkWhereTimIs(timPosition: thePlayer.position)
        }
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
        
        // Detecting collision between a scholar and a platform
        if contact.bodyA.categoryBitMask == GameVariables.ColliderType.platform.rawValue && contact.bodyB.categoryBitMask == GameVariables.ColliderType.scholar.rawValue {
            if let scholarNode = contact.bodyB.node as? ScholarNode {
                scholarNode.setMovementBoundaries(minX: (contact.bodyA.node?.frame.minX)!, maxX: (contact.bodyA.node?.frame.maxX)!)
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
    }
    
    // Method which calculates wether the player touched the top of the platform or not
    func playerTouchingTopOfPlatform(frame: CGRect) -> Bool {
        return (thePlayer.frame.minY - 2.50) < frame.maxY
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


