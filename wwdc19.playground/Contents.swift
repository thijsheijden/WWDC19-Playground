import PlaygroundSupport
import SpriteKit

// Loading the menu scene
let scene = BugTestingScene(fileNamed: "BugTestingScene")
//let scene = MenuScene(size: GameVariables.sceneView.frame.size)
GameVariables.sceneView.presentScene(scene)

// Initializing the menu scene when the playground starts
PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView

// Make sure you have rendered markup turned on!
/*:
 
 ### Welcome to my playground!
 
 This is a fun little game about the morning of the keynote. You are Tim Cook and you need to complete some tasks before launching new and awesome stuff!
 
 Built using SpriteKit, GameplayKit, AVAudioFoundation, CoreML and a lot of time!


*/

