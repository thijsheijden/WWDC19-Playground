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
    var computerNode: SKSpriteNode?
    var tutorialPopup: SceneCompletionNode?
    var dimPanel: SKSpriteNode?
    
    var previousPrediction = ""
    var currentPredictions = [String]()
    var predictionDoneTyping: Bool = true
    
    var recognitionEnabled: Bool = false
    
    var request = [VNRequest]()
    
    // Did move to this scene event
    override public func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        cameraNode = SKCameraNode()
        setupCamera()
        setupPlayer()
        setupAndAddClearCanvasButton()
        setupAndAddComputerNode()
        setupAndAddTextBubble()
        setupAndAddCorrectButton()
        setupCoreMLRequest()
        addTutorialPopup()
    }
    
    // Method for adding the explanation popup
    func addTutorialPopup() {
        tutorialPopup = SceneCompletionNode(size: CGSize(width: 600, height: 400), completionLabel: "This is the testing room. Here you can test if your bug fixes worked.\n\nDraw an apple product on the canvas and Mr. Mac will tell you what it is. If you're happy with the fixes click the checkmark button to sign off on the fixes and go and catch Mr. Clicker.")
        tutorialPopup?.position = CGPoint(x: 0, y: 0)
        tutorialPopup?.zPosition = 101
        tutorialPopup?.textLineNodeLabel?.fontSize = 26
        tutorialPopup?.textLineNodeLabel?.horizontalAlignmentMode = .center
        tutorialPopup?.textLineNodeLabel?.position = CGPoint(x: 5, y: -20)
        tutorialPopup?.textLineNodeLabel?.preferredMaxLayoutWidth = 585
        tutorialPopup?.continueButton?.action = { (button) in
            self.tutorialPopup?.removeFromParent()
            self.dimPanel?.removeFromParent()
            self.startTimer()
            self.setupAndAddCanvasView()
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
    
    // Setting up the player node
    func setupPlayer() {
        thePlayer.setupPlayerNode(texture: SKTexture(imageNamed: "Idle-1"), size: CGSize(width: 64, height: 192), position: CGPoint(x: -350.0, y: -64))
        thePlayer.setupStateMachine()
        self.addChild(thePlayer)
    }
    
    // Setting a 45 second timer which gives the player an alert that it is time to move on or they wont catch mr clicker
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 45.0, repeats: false) { (timer) in
            self.drawingCanvas?.removeFromSuperview()
            self.displayTimeUpPopup()
        }
    }
    
    // Display popup that the time has passed and you should move on to catch mr clicker
    func displayTimeUpPopup() {
        let timeUpPopup = SceneCompletionNode(size: CGSize(width: 600, height: 400), completionLabel: "If you want to catch Mr. Clicker in time for the keynote, you better leave now.")
        timeUpPopup.position = CGPoint(x: 0, y: 0)
        timeUpPopup.zPosition = 101
        timeUpPopup.textLineNodeLabel?.fontSize = 32
        timeUpPopup.textLineNodeLabel?.horizontalAlignmentMode = .center
        timeUpPopup.textLineNodeLabel?.position = CGPoint(x: 5, y: -20)
        timeUpPopup.textLineNodeLabel?.preferredMaxLayoutWidth = 585
        timeUpPopup.continueButton?.action = { (button) in
            if let clickerScene = ClickerScene(fileNamed: "ClickerScene") {
                GameVariables.sceneView.presentScene(clickerScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2.5))
                self.drawingCanvas?.removeFromSuperview()
            }
        }
        addDimPanelBehindPopup()
        self.addChild(timeUpPopup)
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
    
    // Method which starts a timer which fires every 1 second to recognize the drawing
    func startRecognition() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            self.recognize()
        }
    }
    
    // Setting up the camera node
    func setupCamera() {
        self.addChild(cameraNode!)
        camera = cameraNode
    }
    
    // Adding an NSView which will be used as a drawing canvas
    func setupAndAddCanvasView() {
        drawingCanvas = CanvasView(frame: NSRect(x: (self.view?.frame.midX)! - 250, y: (self.view?.frame.midY)! - 140, width: 450.0, height: 450.0))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.view?.addSubview(self.drawingCanvas!)
        }
        startRecognition()
    }
    
    // Method which sets up and adds the computer node to the scene
    func setupAndAddComputerNode() {
        computerNode = SKSpriteNode(texture: SKTexture(imageNamed: "macintosh-sprite1"), color: NSColor.white, size: CGSize(width: 150, height: 150))
        computerNode?.position = CGPoint(x: 300, y: -100.0)
        computerNode?.zPosition = -1
        self.addChild(computerNode!)
    }
    
    // Method which sets up the correct prediction button
    func setupAndAddCorrectButton() {
        let correctButton = ButtonNode(texture: SKTexture(imageNamed: "correct-button"), size: CGSize(width: 80.0, height: 80.0))
        correctButton.position = CGPoint(x: 305, y: -240)
        correctButton.action = { (button) in
            if let clickerScene = ClickerScene(fileNamed: "ClickerScene") {
                GameVariables.sceneView.presentScene(clickerScene, transition: SKTransition.moveIn(with: SKTransitionDirection.right, duration: 2.5))
                self.drawingCanvas?.removeFromSuperview()
            }
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
            computerNode?.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "macintosh-sprite1"), SKTexture(imageNamed: "macintosh-sprite2")], timePerFrame: 0.1), count: 5))
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
    }
    
    func updateCameraPosition() {
        cameraNode?.position = thePlayer.position
    }
    
    // MARK: All CoreML and Vision code
    func setupCoreMLRequest() {
        let my_model = drawnAppleClassifier().model
        
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
        
        let image = drawingCanvas?.snapshot.cgImage
        
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
            print("Unknown key pressed, you might have caps lock turned on!")
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
            print("")
        }
    }
    
    // When a collision is detected in the scene
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


