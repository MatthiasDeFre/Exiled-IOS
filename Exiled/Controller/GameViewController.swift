//
//  GameViewController.swift
//  ScrollviewTest
//
//  Created by Matthias De Fré on 09/11/2018.
//  Copyright © 2018 Matthias De Fré. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var game : Game!
    
    var gScene : GameScene!
    var counter = 0
    
   
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var stone: UILabel!
    @IBOutlet weak var wood: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnUpgrade: UIButton!
    
    @IBOutlet weak var upgradeDescription: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var heading: UIView!
    @IBOutlet weak var mapView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("savegame")
                .appendingPathExtension("json")
        if let loadedGameData = try? Data(contentsOf: archiveURL), let loadedGame = try? JSONDecoder().decode(Game.self, from: loadedGameData) {
            game = loadedGame
        } else {
            game = Game()
        }*/
        
        updateResources()
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        //heading.backgroundColor = UIColor(red: 9/255, green: 95/255, blue: 234/255, alpha: 0.5)
        let backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        heading.backgroundColor = backgroundColor
           bottomView.backgroundColor = backgroundColor
        //heading.roundedCorners(top: false)
      heading.layer.cornerRadius = 8
        //view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                gScene = sceneNode
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                sceneNode.setClickCallback(test: selectTile)
            
                bottomView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
                // Present the scene
                if let view = mapView  {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    gScene.setMap(tiles: game.mapSet.map)
                    
                }
               
            }
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        gScene.rotate()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    func selectTile(rowIndex : Int, colIndex : Int){
        let tile = game.mapSet.selectTile(from: (rowIndex, colIndex))
        let canUpgrade = game.canUpgrade()
        updateSelectedInfo(tile: tile, isUpgradeable: canUpgrade)
    }
    
    func updateSelectedInfo(tile : Tile, isUpgradeable : Bool ) {
      
        if let upgrade = tile.upgrade {
            upgradeDescription.text = TileDictionary.instance.tileDictionary[upgrade]?.description
        } else {
            upgradeDescription.text = tile.description
        }
        btnUpgrade.isEnabled = isUpgradeable
    }
    
    func updateResources() {
        let perTurn = game.resourcesPerTurn
        let current = game.resources
        wood.text = "\(current.wood)+\(perTurn.wood)"
          stone.text = "\(current.stone)+\(perTurn.stone)"
          gold.text = "\(current.gold)+\(perTurn.gold)"
    }
    @IBAction func upgradePressed(_ sender: Any) {
        let upgradeInfo = game.upgradeSelectedBuilding()
        gScene.changeTile(coordinates: upgradeInfo.0, tileType: upgradeInfo.1)
        updateResources()
        btnUpgrade.isEnabled = game.canUpgrade()
    }
    @IBAction func nextTurnPressed(_ sender: Any) {
        game.nextTurn()
        updateResources()
         btnUpgrade.isEnabled = game.canUpgrade()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let jsonEncoder = JSONEncoder()
        do {
        
            let jsonData = try jsonEncoder.encode(game)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            let documentsDirectory =
                FileManager.default.urls(for: .documentDirectory,
                    in: .userDomainMask).first!
            let archiveURL =
                documentsDirectory.appendingPathComponent("savegame")
                    .appendingPathExtension("json")
            try jsonString?.write(to: archiveURL, atomically: true, encoding: .utf8)
        }
        catch {
        }
    }
}
extension UIView {
    func roundedCorners(top: Bool){
        let corners:UIRectCorner = (top ? [.topLeft , .topRight] : [.bottomRight , .bottomLeft])
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii:CGSize(width:8.0, height:8.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
    }
}
