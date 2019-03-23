import Foundation
import SpriteKit

public class GameVariables {
    
    // Public variable which keeps track of on which level the player is so the player can easily reset the level
    public var currentlyOnLevel: String = "GameScene"

    public static let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 1200, height: 600))
    
    // All the cutscene text lines
    public static let firstCutSceneText = "///////////////Hey there!//////{It's 7:00 AM, the morning of the keynote.//////{Before the keynote there are just{3 things I need to do.//////{1. Fix the coreML bugs.//////{2. Test if the bugs are fixed.//////{3. Catch Mr. Clicker...//////{So lets get to work!"
    
    public static let gameSceneText = "//////////Drag bugs to developers to/{get them fixed.//////{You have 60 seconds.//////{Watch out for scholars!//////{Taking selfies with them can/{be very time consuming.."
    
    public static var playerPointingDirection = "right"
    
    enum ColliderType: UInt32 {
        case player = 0
        case bug = 2
        case developer = 4
        case platform = 6
        case nextLevelDoor = 8
        case jumpPad = 10
        case scholar = 12
    }
    
    // All the data for all the bugs
    public static let imageLabels = [["apple", "pear", "kiwi"], ["orange", "apple", "banana"], ["apple", "banana", "kiwi"]]
    public static let correctAnswer = [[true, false, false], [false, false, true], [false, false, true]]
    public static let bugImage = ["apple", "banana", "kiwi"]
    
    // Variable that keeps track of the zoom level multiplication for dragging items, if zoomed out, more x or y needs to be added to the dragged nodes
    public static var zoomMultiplication: CGFloat = 1.5
    
}
