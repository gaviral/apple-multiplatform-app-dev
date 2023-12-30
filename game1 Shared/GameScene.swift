//
//  GameScene.swift
//  game1 Shared
//
//  Created by Aviral Garg on 2023-12-29.
//

import SpriteKit

class GameScene: SKScene {
    
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?

    #if os(iOS) || os(tvOS)
    private var lastTouchPosition: CGPoint?
    #endif

    #if os(OSX)
    private var lastMousePosition: CGPoint?
    #endif

    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            lastTouchPosition = touch.location(in: self)
        }

        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let lastTouch = lastTouchPosition else {
            return
        }
        let touchPosition = touch.location(in: self)
        let movementDelta = CGPoint(x: touchPosition.x - lastTouch.x, y: touchPosition.y - lastTouch.y)

        moveScene(by: movementDelta)
        lastTouchPosition = touchPosition
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }
    }

    private func moveScene(by delta: CGPoint) {
        for node in children {
            node.position = CGPoint(x: node.position.x + delta.x, y: node.position.y + delta.y)
        }
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        lastMousePosition = event.location(in: self)

        if let label = label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)
    }

    override func mouseDragged(with event: NSEvent) {
        guard let lastMouse = lastMousePosition else {
            return
        }
        let mousePosition = event.location(in: self)
        let movementDelta = CGPoint(x: mousePosition.x - lastMouse.x, y: mousePosition.y - lastMouse.y)

        moveScene(by: movementDelta)
        lastMousePosition = mousePosition

        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }

    override func mouseUp(with event: NSEvent) {
        lastMousePosition = nil
        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

    private func moveScene(by delta: CGPoint) {
        for node in children {
            node.position = CGPoint(x: node.position.x + delta.x, y: node.position.y + delta.y)
        }
    }

}
#endif

