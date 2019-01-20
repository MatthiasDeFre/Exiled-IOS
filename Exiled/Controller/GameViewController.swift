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

//Class containing all of the main game logic
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
            //Return back to savegames screen
        case "unwindToSaveGames":
            let viewController = self.navigationController!.viewControllers.filter{$0.isKind(of: SaveGameTableViewController.self)}.first!
            self.navigationController?.popToViewController(viewController, animated: true)
            break

        default:
            fatalError("unknown segue")
        }
    }
    /*
     Update resources
     Update gameScene with the game map
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResources()
        
       
        let backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
     
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
    
    //Auto scale the screen when rotating
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
    
    //Method to select a tile and update the selected tile info
    func selectTile(rowIndex : Int, colIndex : Int){
        let tile = game.mapSet.selectTile(from: (rowIndex, colIndex))
        let canUpgrade = game.canUpgrade()
        updateSelectedInfo(tile: tile, isUpgradeable: canUpgrade)
    }
    
    //Method to update the selectedTile info with the given tile
    func updateSelectedInfo(tile : Tile, isUpgradeable : Bool ) {
      
        //If the tile is upgradeable = Set text to update description ELSE set text to tile description
        if let upgrade = tile.upgrade {
            upgradeDescription.text = TileDictionary.instance.tileDictionary[upgrade]?.description
        } else {
            upgradeDescription.text = tile.description
        }
        btnUpgrade.isEnabled = isUpgradeable
    }
    
    //Method to update the current resources and resources per turn
    func updateResources() {
        let perTurn = game.resourcesPerTurn
        let current = game.resources
        wood.text = "\(current.wood)+\(perTurn.wood)"
          stone.text = "\(current.stone)+\(perTurn.stone)"
          gold.text = "\(current.gold)+\(perTurn.gold)"
    }
    
    //Action to upgrade a tile
    @IBAction func upgradePressed(_ sender: Any) {
        let upgradeInfo = game.upgradeSelectedBuilding()
        gScene.changeTile(coordinates: upgradeInfo.0, tileType: upgradeInfo.1)
        updateResources()
        btnUpgrade.isEnabled = game.canUpgrade()
    }
    //Action to check if the game has ended and if not go to the next turn
    @IBAction func nextTurnPressed(_ sender: Any) {
        
        //If game has ended show an alert to go back to the savedgames screen
        switch game.gameStatus {
        case .lost:
            backToSaveGames(title: "Lost", message: "You have lost and your kingdom lies in ruin...")
            break
        case .won:
             backToSaveGames(title: "Won", message: "You braved yourself against the dangers of this world and made sure your kingdom will live another day!")
            break
        case .normal:
            //Go to the next turn and show alert containing event description and possible actions
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
            break
            
        }
       
    }
    //Method to add an UIAction to the given alertController
    //If the Action is not nill this action will also execute action.executeAction(...)
    func addUIAction(alertController : UIAlertController, title : String, action : EventAction?) {
        let uiAction = UIAlertAction(title: title, style: .default) { (uiAction:UIAlertAction) in
            if let action = action {
                action.executeAction(game: self.game)
            }
            self.gScene.setMap(tiles: self.game.mapSet.map)
            self.updateResources()
            self.btnUpgrade.isEnabled = self.game.canUpgrade()
        }
        alertController.addAction(uiAction)
    }
    
    //Action to save the game
    @IBAction func savePressed(_ sender: Any) {
        do {
            try SaveGameRepository().saveData(element: game)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //Method that will show an alert in case the game has ended, this alert will have 1 action to go back to the savesgames screen
    func backToSaveGames(title: String, message : String) {
        let alertController = CustomAlertViewController(title: title, message: message, preferredStyle: .alert)
        let uiAction = UIAlertAction(title: "Back To Savegames", style: .default) { (uiAction:UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToSaveGames", sender: self)
        }
        alertController.addAction(uiAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

