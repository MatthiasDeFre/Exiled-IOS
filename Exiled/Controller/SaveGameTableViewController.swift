//
//  SaveGameTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 17/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class SaveGameTableViewController: UITableViewController {

    var saveGames = [String]()
    @IBAction func unwindToSaveGames(unwindSegue: UIStoryboardSegue) {
        print("unwind")
        if let gameViewController = unwindSegue.source as? GameViewController {
            if(!saveGames.contains(gameViewController.game.name)) {
                saveGames.append(gameViewController.game.name)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("savegames", isDirectory: true)
        print(documentsURL)
        do {
            try fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        
        if var files = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            files = files.filter{$0.path.hasSuffix(".json")}
            for var file in files {
                print(file.lastPathComponent)
                file.deletePathExtension()
                
                saveGames.append(file.lastPathComponent)
            }

        }
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        print(saveGames)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return saveGames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveGame", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        let saveGame = saveGames[indexPath.row]
        cell.textLabel?.text = saveGame
        // Configure the cell...

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "loadGame":
            var game : Game
            let documentsDirectory =
                FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask).first!
            let archiveURL =
                documentsDirectory.appendingPathComponent("savegames", isDirectory: true).appendingPathComponent(saveGames[tableView.indexPathForSelectedRow!.row])
                    .appendingPathExtension("json")
            if let loadedGameData = try? Data(contentsOf: archiveURL), let loadedGame = try? JSONDecoder().decode(Game.self, from: loadedGameData) {
                game = loadedGame
            } else {
                //Failsafe TODO kill prepare
                game = Game(isCalled: "ErrorLoadingGame", mapSet: MapSet(name:"DEFAULT"))
            }
            let gameViewController = segue.destination as! GameViewController
            gameViewController.game = game;
            break
        case "newGame":
            
            break
        default:
            fatalError("unknown segue")
        }
    }
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0:return "Load Game"
            
        default :return ""
            
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
      
        header?.textLabel?.font = UIFont.systemFont(ofSize: 20)
        header?.textLabel?.textColor = .black
        
    }
    override func tableView(_ tableView: UITableView,
                               editingStyleForRowAt indexPath: IndexPath) ->
        UITableViewCell.EditingStyle {
            return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            
            do {
            
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                  in: .userDomainMask).first!
                try FileManager.default.removeItem(at:
                    documentsDirectory.appendingPathComponent("savegames", isDirectory: true).appendingPathComponent(saveGames[indexPath.row])
                        .appendingPathExtension("json"))
                saveGames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: . automatic)
            } catch {
                print(error)
            }
        }
    }
}
