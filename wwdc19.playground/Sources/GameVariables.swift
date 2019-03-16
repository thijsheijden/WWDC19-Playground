import Foundation
import SpriteKit

public class GameVariables {

    public static let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1200, height: 600))
    
    // All the cutscene text lines
    public static var firstCutSceneText = "Hey there!//////{It's 7:00 AM, the morning of the keynote.//////{I have some things I need to do.//////{First I will need to fix some of the bugs in the{new CoreML release.///{It seems something went wrong during the{training of the models, so we'll have{to fix that."
    
    public static var playerPointingDirection = "right"
    
    enum ColliderType: UInt32 {
        case player = 0
        case bug = 2
        case developer = 4
        case platform = 6
        case nextLevelDoor = 8
        case jumpPad = 10
    }
    
    // All the data for all the bugs
    public static let imageLabels = [["apple", "pear", "kiwi"], ["orange", "apple", "banana"], ["apple", "banana", "kiwi"]]
    public static let correctAnswer = [[true, false, false], [false, false, true], [false, false, true]]
    public static let bugImage = ["apple", "banana", "kiwi"]
    
}
