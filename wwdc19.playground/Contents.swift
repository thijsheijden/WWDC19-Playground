import PlaygroundSupport
import SpriteKit

// Make sure you have rendered markup turned on!
/*:
 
 # Welcome to 'The Morning of the Keynote'!
 
 ### This is a fun little game about the morning of the keynote. You are Tim Cook and you need to complete some tasks before launching new and awesome stuff!
 
 ### Built using SpriteKit, GameplayKit, AVFoundation, CoreML, Vision and CreateML!
 
 ### Please open the live view and drag it out far enough so that there are bars on both sides and none of the view is cut off.
 
 ### For the best gameplay experience use a mouse, as the trackpad can be quite tricky to use during playing.
 
 ### This was my first time using SpriteKit and I really enjoyed it! Have fun playing the game!
 
 [Camera sound effect](https://www.youtube.com/watch?v=2umf4afzrjE)
 
 [Trampoline sound effect](https://www.youtube.com/watch?v=iew9op9aPLQ)
 
 [Tada sound effect](https://www.youtube.com/watch?v=bjxf-eQWKoo)
 
 [Minecraft Font](https://www.dafont.com/minecraft.font)
*/

let scene = MenuScene(size: GameVariables.sceneView.frame.size)
GameVariables.sceneView.presentScene(scene)

// Initializing the menu scene when the playground starts
PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView
