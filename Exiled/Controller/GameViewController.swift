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
    
   
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnUpgrade: UIButton!
    @IBOutlet weak var upgradeDescription: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var heading: UIView!
    @IBOutlet weak var mapView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        heading.backgroundColor = UIColor(red: 9/255, green: 95/255, blue: 234/255, alpha: 0.5)
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
    @IBAction func upgradePressed(_ sender: Any) {
        let upgradeInfo = game.upgradeSelectedBuilding()
        gScene.changeTile(coordinates: upgradeInfo.0, tileType: upgradeInfo.1)
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
