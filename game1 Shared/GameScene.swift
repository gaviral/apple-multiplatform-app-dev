//
//  GameScene.swift
//  game1 Shared
//
//  Created by Aviral Garg on 2023-12-29.
//

import SpriteKit

// GameScene class inheriting from SKScene, which is the basic scene for all content in a SpriteKit game.
class GameScene: SKScene {
    
    // Private variable declarations for label and a shape node.
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?

    // Static method to create a new GameScene instance.
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        // SKScene(fileNamed: "GameScene") attempts to find and load a scene file with the specified name.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()  // Aborts execution if the scene cannot be loaded.
        }
        
        // Sets the scale mode of the scene to aspect fill.
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    // Method to set up the scene.
    func setUpScene() {
        // Retrieves the label node from the scene and stores it for later use.
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0  // Sets the label's initial transparency to invisible.
            label.run(SKAction.fadeIn(withDuration: 2.0))  // Fades in the label over 2 seconds.
        }
        
        // Creates a shape node (spinnyNode) for interaction.
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            // Sets up an action for the spinnyNode to rotate forever.
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            // Sets up a sequence of actions for fading out and removal.
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    // Override method called when the scene is presented by a view.
    override func didMove(to view: SKView) {
        self.setUpScene()  // Calls the setup method to configure the scene.
    }

    // Method to create and add a spinning node at a specific position.
    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos  // Sets the position of the spinny node.
            spinny.strokeColor = color  // Sets the color of the spinny node.
            self.addChild(spinny)  // Adds the spinny node to the scene.
        }
    }
    
    // Override method called before each frame is rendered.
    override func update(_ currentTime: TimeInterval) {
        // Implement game logic here.
    }
}

#if os(iOS) || os(tvOS)
// Extension for touch-based event handling (iOS and tvOS).
extension GameScene {

    // Handles the beginning of a touch.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            // Runs a 'Pulse' action on the label.
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        // Iterates over all touches and creates a green spinny node at the touch location.
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    // Handles the movement of touches.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Creates a blue spinny node at the new touch locations.
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    // Handles the end of a touch.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Creates a red spinny node at the touch end locations.
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
    // Handles the cancellation of a touch.
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Creates a red spinny node at the touch cancellation locations.
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }
    
}
#endif

#if os(OSX)
// Extension for mouse-based event handling (macOS).
extension GameScene {

    // Handles mouse-down events.
    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }
    
    // Handles mouse-dragged events.
    override func mouseDragged(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    // Handles mouse-up events.
    override func mouseUp(with event: NSEvent) {
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif
