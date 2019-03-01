import SpriteKit

class ButtonNode: SKSpriteNode {
    
    // 1 - action to be invoked when the button is tapped/clicked on
    var action: ((ButtonNode) -> Void)?
    
    // 2
    var isSelected: Bool = false {
        didSet {
            alpha = isSelected ? 0.8 : 1
        }
    }
    
    // MARK: - Initialisers
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // 3
    init(texture: SKTexture) {
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        isUserInteractionEnabled = true
    }
    
    // MARK: - Cross-platform user interaction handling
    
    // 4
    override func touchesBegan(with event: NSEvent) {
        action?(self)
    }
    
    override func mouseDown(with event: NSEvent) {
        action?(self)
    }
}
