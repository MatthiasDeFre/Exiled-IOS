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
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) {
            guard let map = childNode(withName: "testB") as? SKTileMapNode else {
                fatalError("Background node not loaded")
            }
            print("loc ",location)
            let column = map.tileColumnIndex(fromPosition: location)
            let row = map.tileRowIndex(fromPosition: location)
            guard column >= 0, row >= 0, column < map.numberOfColumns, row < map.numberOfRows else{
                return
            }
            
            map.setTileGroup(map.tileSet.tileGroups.last, forColumn: column, row: row)
            print(column, " r", row)
            centerNode?.run(SKAction.move(to: location, duration: 1))
            clickCall(row, column)
        }
    }
    @IBAction func handleTapFrom(recognizer: UITapGestureRecognizer) {

        if recognizer.state != .ended {
            return
        }
        
        let recognizorLocation = recognizer.location(in: recognizer.view!)
        let location = self.convertPoint(fromView: recognizorLocation)
        
      
        
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
    
    func setMap(tiles : [[Int]]) {
        guard var map = childNode(withName: "testB") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        map.removeFromParent()
        map = SKTileMapNode(tileSet: map.tileSet, columns: tiles[0].count, rows: tiles.count, tileSize: CGSize(width: 110, height: 128))
        map.name = "testB"
        
        self.addChild(map)
    
        for (rowIndex, tileRow) in tiles.enumerated() {
            print("Row ",rowIndex)
            for (colIndex, tile) in tileRow.enumerated() {
                map.setTileGroup(map.tileSet.tileGroups.first(where: {$0.name == TileDictionary.instance.getTileType(type: tile)}), forColumn: colIndex, row: rowIndex)
                 print("Col ",colIndex)
            }
          
        }
    }
}
