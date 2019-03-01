import PlaygroundSupport
import SpriteKit

// Load the SKScene from 'GameScene.sks'
let scene = MenuScene(size: GameVariables.sceneView.bounds.size)
GameVariables.sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView
