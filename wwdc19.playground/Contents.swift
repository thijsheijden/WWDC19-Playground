import PlaygroundSupport
import SpriteKit

// Make sure you have rendered markup turned on!
/*:
 
 # Welcome to my playground!
 
 This is a fun little game about the morning of the keynote. You are Tim Cook and you need to complete some tasks before launching new and awesome stuff!
 
 Built using SpriteKit, GameplayKit, AVAudioFoundation, CoreML, Vision and CreateML!
 
 Please open the live view and drag it out far enough so that there are bars on both sides and none of the view is cut off.
 
 This was my first time using SpriteKit and I really enjoyed it! Have fun playing the game!
 
 For the best gameplay experience use a mouse, as the trackpad can be quite tricky to use during playing.


*/

let scene = MenuScene(size: GameVariables.sceneView.frame.size)
GameVariables.sceneView.presentScene(scene)

// Initializing the menu scene when the playground starts
PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView
