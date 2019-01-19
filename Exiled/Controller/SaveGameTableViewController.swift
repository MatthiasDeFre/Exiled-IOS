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
        
        if(!SaveGameRepository().directoryExists) {
            guard let _ = try? SaveGameRepository().createDirectory() else {
                return
            }
        }
        saveGames = SaveGameRepository().savedData
        
        let backButton = UIBarButtonItem(title: "Save Games", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OptimusPrincepsSemiBold", size: 20)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
    }

    override func viewWillAppear(_ animated: Bool) {
       
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
          cell.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: cell.textLabel!.font.pointSize)
        // Configure the cell...

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "loadGame":
          
            do {
                let gameViewController = segue.destination as! GameViewController
                   gameViewController.game = try SaveGameRepository().loadData(named: saveGames[tableView.indexPathForSelectedRow!.row])
            } catch {
             print(error)
            }
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
      
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
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
                
                try SaveGameRepository().removeData(named: saveGames[indexPath.row])
                saveGames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: . automatic)
            } catch {
                print(error)
            }
        }
    }
}
