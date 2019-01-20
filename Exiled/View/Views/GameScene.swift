//
//  GameScene.swift
//  ScrollviewTest
//
//  Created by Matthias De Fré on 09/11/2018.
//  Copyright © 2018 Matthias De Fré. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var clickCall : ((Int, Int) -> ())!
    var scrollView: SwiftySKScrollView!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var cam : SKCameraNode?
    var centerNode : SKSpriteNode?
    var testLabel : SKLabelNode!
    var selectionBox : SKShapeNode?
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    override func sceneDidLoad() {
       
        self.lastUpdateTime = 0
      
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
     
      
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        cam = SKCameraNode();
        self.camera = cam

        centerNode = self.childNode(withName: "testNode") as? SKSpriteNode
        testLabel = SKLabelNode(text: "Test")
        testLabel.color = .white
        testLabel.position = CGPoint(x: -self.size.width / 2 + 75, y: self.size.height / 2 - 50)
        self.camera?.addChild(testLabel)
        self.addChild(cam!);
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        let pinchReq = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchFrom(recognizer:)))
        let panReq = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(_:)))
        view.addGestureRecognizer(pinchReq)
        view.addGestureRecognizer(panReq)
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) {
           
        }
    }
 
    @IBAction func handleTapFrom(recognizer: UITapGestureRecognizer) {
       
        if recognizer.state != .ended {
            return
        }
        
        let recognizorLocation = recognizer.location(in: recognizer.view!)
        let location = self.convertPoint(fromView: recognizorLocation)
        guard let map = childNode(withName: "testB") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        print("loc ",location)
        let column = map.tileColumnIndex(fromPosition: location)
        let row = map.tileRowIndex(fromPosition: location)
        guard column >= 0, row >= 0, column < map.numberOfColumns, row < map.numberOfRows else{
            return
        }
        if let selectionBox = selectionBox {
            selectionBox.removeFromParent()
        }
        
        selectionBox = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        let rect = CGRect(x: 0.0, y: 0.0, width: 128, height: 128)
        
        let path = roundedPolygonPath(rect: rect, lineWidth: 0, sides: 6, cornerRadius: 0, rotationOffset: CGFloat(Double.pi / 2.0))
        selectionBox = SKShapeNode(path: path.cgPath)
        var point =  map.centerOfTile(atColumn: column, row: row)
        point.x = point.x - 55
        point.y = point.y - 55
        
        selectionBox!.position = point
        selectionBox!.strokeColor = .black
        
        map.addChild(selectionBox!)
        
        print(column, " r", row)
        //centerNode?.run(SKAction.move(to: location, duration: 1))
        clickCall(row, column)
      
        
    }
    @IBAction func handlePinchFrom(recognizer: UIPinchGestureRecognizer? = nil) {
        guard let gesture = recognizer else {
            return
        }
        if (gesture.state == .began || gesture.state == .changed) && gesture.scale > 0.20 && gesture.scale < 2 {
            print(gesture.scale)
            self.camera?.setScale(gesture.scale)
        }
    }
   var previousCameraPoint = CGPoint.zero
    @IBAction func handlePanFrom(_ sender: UIPanGestureRecognizer) {
        
        // The camera has a weak reference, so test it
        guard let camera = self.centerNode else {
            return
        }
        
        // If the movement just began, save the first camera position
        if sender.state == .began {
            previousCameraPoint = camera.position
        }
        // Perform the translation
       
        let translation = sender.translation(in: self.view)
        
        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1,
            y: previousCameraPoint.y + translation.y
        )
        guard let map = childNode(withName: "testB") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        let column = map.tileColumnIndex(fromPosition: newPosition)
        let row = map.tileRowIndex(fromPosition: newPosition)
        guard column >= 0, row >= 0, column < map.numberOfColumns, row < map.numberOfRows else{
            return
        }
        print("Col", column, "Row", row)
        camera.position = newPosition
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        super.update(currentTime)
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        if let camera = cam, let center = centerNode {
            camera.position = center.position
        }
        self.lastUpdateTime = currentTime
    }
    typealias test = (_ : Int, _ colIndex : Int) -> Void
   
    func rotate(){
        self.camera?.setScale(2)
       // testLabel.position = CGPoint(x: -screenWidth, y: screenHeight)
        
    }
    func setClickCallback(test : @escaping test) {
        clickCall = test
    }
    
    func setMap(tiles : [[TileType]]) {
        guard var map = childNode(withName: "testB") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        map.removeFromParent()
        map = SKTileMapNode(tileSet: map.tileSet, columns: tiles[0].count, rows: tiles.count, tileSize: CGSize(width: 128, height: 128))
        map.name = "testB"
        
        self.addChild(map)
    
        for (rowIndex, tileRow) in tiles.enumerated() {
          
            for (colIndex, tile) in tileRow.enumerated() {
            
                map.setTileGroup(map.tileSet.tileGroups.first(where: {$0.name == tile.rawValue}), forColumn: colIndex, row: rowIndex)
               
            }
          
        }
    }
    func changeTile(coordinates : (Int, Int), tileType : TileType) {
        guard var map = childNode(withName: "testB") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        map.setTileGroup(map.tileSet.tileGroups.first(where: {$0.name == tileType.rawValue}), forColumn: coordinates.1, row: coordinates.0)
    }
    
}
//SOURCE: https://gist.github.com/henrinormak/96c8918e7baa23d5b10a
public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
    let path = UIBezierPath()
    let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides) // How much to turn at every corner
    let width = min(rect.size.width, rect.size.height)        // Width of the square
    
    let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
    
    // Radius of the circle that encircles the polygon
    // Notice that the radius is adjusted for the corners, that way the largest outer
    // dimension of the resulting shape is always exactly the width - linewidth
    let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
    
    // Start drawing at a point, which by default is at the right hand edge
    // but can be offset
    var angle = CGFloat(rotationOffset)
    
    let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
    path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
    
    for _ in 0..<sides {
        angle += theta
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
        let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
        
        path.addLine(to: start)
        path.addQuadCurve(to: end, controlPoint: tip)
    }
    
    path.close()
    
    // Move the path to the correct origins
    let bounds = path.bounds
    let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
    path.apply(transform)
    
    return path
}


