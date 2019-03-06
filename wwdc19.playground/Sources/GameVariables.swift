import Foundation
import SpriteKit

public class GameVariables {

    public static let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1200, height: 600))
    
    // All the cutscene text lines
    public static var firstCutSceneText = ["7:30 AM, morning of the WWDC19 keynote.", "Test test test"]
    
    public static var playerPointingDirection = "right"
    
    enum ColliderType: UInt32 {
        case player = 0
        case bug = 1
        case developer = 2
        case platform = 3
        case nextLevelDoor = 4
    }
    
    // All the data for all the bugs
    public static let imageLabels = [["apple", "pear", "kiwi"], ["orange", "apple", "banana"], ["apple", "banana", "kiwi"]]
    public static let correctAnswer = [[true, false, false], [false, false, true], [false, false, true]]
    public static let bugImage = ["apple", "banana", "kiwi"]
    
}
