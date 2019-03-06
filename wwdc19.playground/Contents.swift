import PlaygroundSupport
import SpriteKit

// Load the SKScene from 'GameScene.sks'
let scene = GameScene(fileNamed: "GameScene")
GameVariables.sceneView.presentScene(scene)

// Initializing the menu scene when the playground starts
PlaygroundSupport.PlaygroundPage.current.liveView = GameVariables.sceneView
