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
    }
    override func viewWillAppear(_ animated: Bool) {
        mapSetTableView.mapSets = MapSetRepository().savedData
        print(mapSetsArray)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return tableView.bounds.height - UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    // MARK: - Table view data source
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
