import SpriteKit

public class WWDC19Scene: SKScene {
    
    
    override public func didMove(to view: SKView) {
        addGlow()
    }
    
    // Method which adds nice glow to the keynote sign
    func addGlow() {
        for node in self.children {
            if node.name == "glow" || node.name == "glow-menu" {
                if let spriteNode = node as? SKSpriteNode {
                    spriteNode.addGlow(radius: 60)
                }
            }
        }
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
    }
    
}
