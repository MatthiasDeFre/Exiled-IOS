//
//  NewGameTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 17/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class NewGameTableViewController: UITableViewController {
    
    var mapSetsArray : [String]!
     let mapSetTableView = MapSetTableView();
    @IBOutlet weak var mapSets: UITableView!
    @IBOutlet weak var txtGameName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        mapSets.delegate = mapSetTableView
        mapSets.dataSource = mapSetTableView
        mapSets.register(UITableViewCell.self, forCellReuseIdentifier: "mapSet")
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        mapSets.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
       txtGameName.backgroundColor = UIColor(patternImage: UIImage(named: "inputfield")!)
        txtGameName.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
        if(!MapSetRepository().directoryExists) {
            do {
                try MapSetRepository().createDirectory()
                try MapSetRepository().createDefaultMapSets() 
            } catch {
                print(error)
            }
        }
        mapSetTableView.mapSets = MapSetRepository().savedData
        print(mapSetsArray)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
             return 100
        case 1:
             return tableView.bounds.height - UITableView.automaticDimension
        default:
              return UITableView.automaticDimension
        }
       
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0:return "Game Name"
        
        default :return ""
            
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
        header?.textLabel?.textColor = .black
        
    }
    
    // MARK: - Table view data source
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if txtGameName.text!.isEmpty || mapSets.indexPathForSelectedRow == nil {
              let alertController = CustomAlertViewController(title: "Cannot Start Game", message: "You haven't entered a name or selected a mapset for your game", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("SEQUE NEW GAME")
        let selectedMapSet = mapSetTableView.mapSets[mapSets.indexPathForSelectedRow!.row]
        print(selectedMapSet)
        guard let loadedMapSet = try? MapSetRepository().loadData(named: selectedMapSet) else {
            return
        }
        let game = Game(isCalled: txtGameName.text!, mapSet: loadedMapSet)
        let gameViewController = segue.destination as! GameViewController
        let jsonEncoder = JSONEncoder()
        do {
            
            let jsonData = try jsonEncoder.encode(game)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            let documentsDirectory =
                FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask).first!
            let archiveURL =
                documentsDirectory.appendingPathComponent("savegames", isDirectory: true).appendingPathComponent(game.name)
                    .appendingPathExtension("json")
            try jsonString?.write(to: archiveURL, atomically: true, encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
        }
        gameViewController.game = game;
    }

   

}
