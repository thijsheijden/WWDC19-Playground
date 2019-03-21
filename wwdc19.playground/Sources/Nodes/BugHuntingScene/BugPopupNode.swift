import SpriteKit

protocol BugPopupCorrectAnswerDelegate {
    func answeredCorrectly()
}

class BugPopupNode: SKSpriteNode {
    
    var delegate: BugPopupCorrectAnswerDelegate?
    
    var bugData: BugDataStruct?
    
    var answerButtonLocations = [CGPoint]()
    
    let fadeInAction = SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.fadeIn(withDuration: 1.0)])
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(size: CGSize, bugData: BugDataStruct) {
        super.init(texture: nil, color: SKColor.white, size: size)
        self.alpha = 0.0
        self.zPosition = 101
        self.bugData = bugData
        isUserInteractionEnabled = true
        let minX = self.frame.minX
        let maxX = self.frame.maxX
        let minY = self.frame.minY
        answerButtonLocations = [CGPoint(x: minX + 100.0, y: minY + 100.0), CGPoint(x: self.frame.midX - 50.0, y: minY + 100.0), CGPoint(x: maxX - 200.0, y: minY + 100.0)]
        addPopupImage()
        addOptionButtons()
    }
    
    func addPopupImage() {
        let imageNode = SKSpriteNode(imageNamed: (bugData?.imageName)!)
        imageNode.size = CGSize(width: 500.0, height: 500.0)
        imageNode.position = CGPoint(x: 0, y: 100.0)
        imageNode.alpha = 0.0
        fadeInImage(image: imageNode)
        self.addChild(imageNode)
    }
    
    func addOptionButtons() {
        for i in 0...(bugData?.answerLabels.count)!-1 {
            let answerButton = BugPopupAnswerButtonNode(text: (bugData?.answerLabels[i])!, size: CGSize(width: 100.0, height: 50.0), answer: (bugData?.answerLabels[i])!, correctAnswer: (bugData?.correctAnswer[i])!)
            answerButton.position = answerButtonLocations[i]
            setupButtonActions(button: answerButton)
            fadeInButton(button: answerButton)
            self.addChild(answerButton)
        }
    }
    
    func fadeInButton(button: BugPopupAnswerButtonNode) {
        button.run(fadeInAction)
    }
    
    func fadeInImage(image: SKSpriteNode) {
        image.run(fadeInAction)
    }
    
    func setupButtonActions(button: BugPopupAnswerButtonNode) {
        button.action = { (button) in
            if button.correctAnswer! {
                self.removeFromParent()
                
                // Calling the delegate when the user selects the correct answer
                self.delegate?.answeredCorrectly()
            }
        }
    }
}

