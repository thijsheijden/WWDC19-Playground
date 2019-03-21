import PlaygroundSupport
import SpriteKit
import CoreML
import Vision

public class BugTestingScene: SKScene, SKPhysicsContactDelegate {
    
    // Global Nodes
    var cameraNode: SKCameraNode?
    var thePlayer: PlayerNode = PlayerNode()
    var drawingCanvas: CanvasView?
    var resultTextBubble: TextLineNode?
    
    var previousPrediction = ""
    var currentPredictions = [String]()
    var predictionDoneTyping: Bool = true
    
    var request = [VNRequest]()
    
    // Did move to this scene event
    override public func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        setupCamera()
        setupPlayer()
        setupAndAddCanvasView()
        setupAndAddClearCanvasButton()
        setupAndAddComputerNode()
        setupAndAddTextBubble()
        setupAndAddCorrectButton()
        setupCoreMLRequest()
    }
    
    // Setting up the player node
    func setupPlayer() {
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: -250.0, y: -64))
        thePlayer.setupStateMachine()
        self.addChild(thePlayer)
    }
    
    // Method which sets up the clear button for the canvas
    func setupAndAddClearCanvasButton() {
        let clearButton = ButtonNode(texture: SKTexture(imageNamed: "clear-button"), size: CGSize(width: 256.0, height: 128.0))
        clearButton.position = CGPoint(x: -25.0, y: -250.0)
        clearButton.action = { (button) in
            self.drawingCanvas?.clearCanvas()
        }
        self.addChild(clearButton)
    }
    
    // Setting up the camera node
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
    // Adding an NSView which will be used as a drawing canvas
    func setupAndAddCanvasView() {
        drawingCanvas = CanvasView(frame: NSRect(x: (self.view?.frame.midX)! - 250, y: (self.view?.frame.midY)! - 140, width: 450.0, height: 450.0))
        self.view?.addSubview(drawingCanvas!)
    }
    
    // Method which sets up and adds the computer node to the scene
    func setupAndAddComputerNode() {
        let computerNode = SKSpriteNode(texture: SKTexture(imageNamed: "macintosh-sprite1"), color: NSColor.white, size: CGSize(width: 150, height: 150))
        computerNode.position = CGPoint(x: 300, y: -100.0)
        computerNode.zPosition = -1
        self.addChild(computerNode)
    }
    
    // Method which sets up the correct prediction button
    func setupAndAddCorrectButton() {
        let correctButton = ButtonNode(texture: SKTexture(imageNamed: "correct-button"), size: CGSize(width: 80.0, height: 80.0))
        correctButton.position = CGPoint(x: 305, y: -240)
        correctButton.action = { (button) in
            print("Correct prediction")
        }
        self.addChild(correctButton)
    }
    
    // Method which sets up and adds the text bubble node for the result of vision request
    func setupAndAddTextBubble() {
        resultTextBubble = TextLineNode(texture: SKTexture(imageNamed: "text-bubble"), size: CGSize(width: 260, height: 105))
        resultTextBubble?.position = CGPoint(x: 430, y: 28)
        resultTextBubble?.zPosition = -1
        self.addChild(resultTextBubble!)
    }
    
    // Method to update the text in the computer text bubble
    func updatePredictionTextBubbleLabel() {
        if predictionDoneTyping {
            resultTextBubble?.textLineNodeLabel?.text = ""
            predictionDoneTyping = false
            let text = currentPredictions[0]
            resultTextBubble?.startTypingText(text: text, timeBetweenChars: 0.1, removeOnCompletion: false) { () -> Void in
                self.predictionDoneTyping = true
                self.currentPredictions.remove(at: 0)
                if self.currentPredictions.count > 0 {
                    self.updatePredictionTextBubbleLabel()
                }
            }
        }
    }
    
    // Called before every frame update
    override public func update(_ currentTime: TimeInterval) {
        thePlayer.getMovementSpeed()
        
        // Run prediction on the canvas view
        recognize()
    }
    
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    // MARK: All CoreML and Vision code
    func setupCoreMLRequest() {
        let my_model = pictionairy().model
        
        guard let model = try? VNCoreMLModel(for: my_model) else {
            fatalError("Cannot load Core ML Model")
        }
        
        // set up request
        let pictionairy_request = VNCoreMLRequest(model: model, completionHandler: handlePictionairyClassification)
        self.request = [pictionairy_request]
    }
    
    //Function that handles the classification
    func handlePictionairyClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            return
        }
        
        let classification = observations
            .compactMap({ $0 as? VNClassificationObservation  })
            .filter({$0.confidence > 0.9})                      // filter confidence > 90%
            .map({$0.identifier})                               // map the identifier as answer
        
        if classification.first != previousPrediction && classification.first != nil {
            previousPrediction = classification.first!
            currentPredictions.append(classification.first!)
            updatePredictionTextBubbleLabel()
        }
        
    }
    
    //Functiont that initializes the recognition process and is called every second
    func recognize() {
        // The model takes input with 12 by 120 pixels, here we take a snapshot of the drawview and resize is before feeding it into our neural net.
        
        let image = drawingCanvas?.snapshot.cgImage.resize()
        
        let imageRequest = VNImageRequestHandler(cgImage: image!, options: [:])
        do {
            try imageRequest.perform(request)
        }
        catch {
            print(error)
        }
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


