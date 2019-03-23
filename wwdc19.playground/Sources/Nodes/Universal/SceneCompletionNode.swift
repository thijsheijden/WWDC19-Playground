import SpriteKit

class SceneCompletionNode: SKSpriteNode {
    
    var textLineNodeLabel: SKLabelNode?
    var continueButton: ButtonNode?
        
    init(size: CGSize, completionLabel: String) {
        super.init(texture: nil, color: NSColor.white, size: size)
        addCompletionLabel(labelText: completionLabel)
        addContinueButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func addCompletionLabel(labelText: String) {
        textLineNodeLabel = SKLabelNode(text: labelText)
        textLineNodeLabel?.fontName = "Minecraft"
        textLineNodeLabel?.fontSize = 30.0
        textLineNodeLabel?.position = CGPoint(x: self.frame.midX, y: self.frame.midX + ((textLineNodeLabel?.fontSize)! / 2))
        textLineNodeLabel?.horizontalAlignmentMode = .center
        textLineNodeLabel?.fontColor = NSColor.black
        textLineNodeLabel?.numberOfLines = 0
        self.addChild(textLineNodeLabel!)
    }
    
    func addContinueButton() {
        continueButton = ButtonNode(texture: SKTexture(imageNamed: "continue-button"), size: CGSize(width: 200.0, height: 75.0))
        continueButton?.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 50)
        self.addChild(continueButton!)
    }
}

