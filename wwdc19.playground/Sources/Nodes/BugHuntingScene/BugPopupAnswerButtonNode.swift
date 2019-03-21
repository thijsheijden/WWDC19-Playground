import SpriteKit

class BugPopupAnswerButtonNode: SKSpriteNode {
    
    var action: ((BugPopupAnswerButtonNode) -> Void)?
    
    var answer: String?
    var correctAnswer: Bool?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(text: String, size: CGSize, answer: String, correctAnswer: Bool) {
        super.init(texture: nil, color: SKColor.white, size: size)
        self.alpha = 0.0
        isUserInteractionEnabled = true
        self.answer = answer
        self.correctAnswer = correctAnswer
        setupLabel()
    }
    
    func setupLabel() {
        let label = SKLabelNode(text: answer)
        label.fontName = "Minecraft"
        label.fontColor = NSColor.black
        label.fontSize = 32.0
        label.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(label)
    }
    
    override func touchesBegan(with event: NSEvent) {
        action?(self)
    }
    
    override func mouseDown(with event: NSEvent) {
        action?(self)
    }
}

