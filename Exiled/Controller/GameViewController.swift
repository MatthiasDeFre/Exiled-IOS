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
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToSaveGames":
            let viewController = self.navigationController!.viewControllers.filter{$0.isKind(of: SaveGameTableViewController.self)}.first!
            self.navigationController?.popToViewController(viewController, animated: true)
            break

        default:
            fatalError("unknown segue")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResources()
        
       
        let backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        heading.backgroundColor = backgroundColor
           bottomView.backgroundColor = backgroundColor
        
      heading.layer.cornerRadius = 8
     
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
        if let event = game.nextTurn() {
            let alertController = CustomAlertViewController(title: event.title, message: event.description, preferredStyle: .alert)
            
            if event.actions.count == 0 {
               addUIAction(alertController: alertController, title: "Ok", action: nil)
            }
            for action in event.actions {
                 addUIAction(alertController: alertController, title: action.description, action: action)
            }
           
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            updateResources()
            btnUpgrade.isEnabled = game.canUpgrade()
        }
       
    }
    func addUIAction(alertController : UIAlertController, title : String, action : EventAction?) {
        let uiAction = UIAlertAction(title: title, style: .default) { (uiAction:UIAlertAction) in
            if let action = action {
                action.executeAction(game: self.game)
            }
        
            self.updateResources()
            self.btnUpgrade.isEnabled = self.game.canUpgrade()
        }
        alertController.addAction(uiAction)
    }
    @IBAction func savePressed(_ sender: Any) {
        do {
            try SaveGameRepository().saveData(element: game)
        }
        catch {
            print(error.localizedDescription)
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
