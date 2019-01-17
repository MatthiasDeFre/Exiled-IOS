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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
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

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return saveGames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveGame", for: indexPath)
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
                documentsDirectory.appendingPathComponent("savegame")
                    .appendingPathExtension("json")
            if let loadedGameData = try? Data(contentsOf: archiveURL), let loadedGame = try? JSONDecoder().decode(Game.self, from: loadedGameData) {
                game = loadedGame
            } else {
                game = Game()
            }
            let gameViewController = segue.destination as! GameViewController
            gameViewController.game = game;
            break
        
        default:
            fatalError("unknown segue")
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
