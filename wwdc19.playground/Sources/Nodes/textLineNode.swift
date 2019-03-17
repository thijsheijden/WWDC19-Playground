import SpriteKit

class TextLineNode: SKSpriteNode {
    
    var textLineNodeLabel: SKLabelNode?
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: NSColor.white, size: size)
        addLabelToSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func addLabelToSelf() {
        textLineNodeLabel = SKLabelNode(text: "")
        textLineNodeLabel?.fontName = "Minecraft"
        textLineNodeLabel?.position = CGPoint(x: self.frame.minX + 25, y: self.frame.maxY - 50)
        textLineNodeLabel?.verticalAlignmentMode = .center
        textLineNodeLabel?.horizontalAlignmentMode = .left
        textLineNodeLabel?.fontColor = NSColor.black
        self.addChild(textLineNodeLabel!)
    }
    
    func startTypingText(text: String) {
        textLineNodeLabel?.typeOutText(text: text) { () -> Void in
            // TODO: Find a way to remove this node
        }
    }
    
}

