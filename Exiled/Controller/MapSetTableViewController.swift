//
//  MapSetTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class MapSetTableViewController: UITableViewController {

    var mapSets = [String]()
    let mapSetRepo = MapSetRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!mapSetRepo.directoryExists) {
            do {
                try mapSetRepo.createMapSetDirectory()
            } catch {
                print(error)
            }
        }
        try! mapSetRepo.createDefaultMapSets()
        mapSets = mapSetRepo.savedMapSets
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mapSets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapSet", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        let mapSet = mapSets[indexPath.row]
        cell.textLabel?.text = mapSet
   
        
        return cell
    }
   
}
