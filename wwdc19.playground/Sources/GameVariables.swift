import Foundation
import SpriteKit

public class GameVariables {

    public static let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1200, height: 600))
    
    public static var playerPointingDirection = "right"
    
    enum ColliderType: UInt32 {
        case player = 0
        case bug = 1
        case developer = 2
        case platform = 3
    }
    
    
    
    // All the data for all the bugs
    public static let imageLabels = [["apple", "pear", "kiwi"], ["orange", "apple", "banana"]]
    public static let correctAnswer = [[true, false, false], [false, false, true]]
    public static let bugImage = ["apple", "banana"]
    
}
