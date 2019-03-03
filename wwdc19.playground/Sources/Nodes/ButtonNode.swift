import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var action: ((ButtonNode) -> Void)?
    
    var isSelected: Bool = false {
        didSet {
            alpha = isSelected ? 0.8 : 1
        }
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize) {
        super.init(texture: texture, color: SKColor.white, size: size)
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(with event: NSEvent) {
        action?(self)
    }
    
    override func mouseDown(with event: NSEvent) {
        action?(self)
    }
}
