import SpriteKit

class BugPopupNode: SKSpriteNode {
    
    var bugData: BugDataStruct?
    
    var answerButtonLocations = [CGPoint(x: 0.0, y: 100.0), CGPoint(x: 50.0, y: 100.0), CGPoint(x: 100.0, y: 100.0)]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(texture: SKTexture, size: CGSize, bugData: BugDataStruct) {
        super.init(texture: texture, color: SKColor.white, size: size)
        self.bugData = bugData
        isUserInteractionEnabled = true
        addOptionButtons()
    }
    
    func addOptionButtons() {
        for i in 0...(bugData?.answerLabels.count)!-1 {
            let answerButton = ButtonNode(texture: SKTexture(imageNamed: "start"), size: CGSize(width: 50.0, height: 25.0))
            answerButton.position = answerButtonLocations[i]
            self.addChild(answerButton)
        }
    }
}

