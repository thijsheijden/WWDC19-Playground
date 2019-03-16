import PlaygroundSupport
import SpriteKit

// Loading the menu scene
let scene = ScholarsSelfieScene(fileNamed: "ScholarScene")
GameVariables.sceneView.presentScene(scene)

// Initializing the menu scene when the playground starts
PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView

/*:
 
 ### Welcome to my playground!
 
 This is a fun little game about the morning before the keynote. You are Tim Cook and you need to complete some tasks before launching new and awesome stuff!
 
 Built using SpriteKit, GameplayKit, AVAudioFoundation and some CoreML


*/
