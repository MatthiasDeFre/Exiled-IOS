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
                try mapSetRepo.createDirectory()
            } catch {
                print(error)
            }
        }
        try! mapSetRepo.createDefaultMapSets()
         self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        mapSets = mapSetRepo.savedData
    }

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mapSets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapSet", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        let mapSet = mapSets[indexPath.row]
        cell.textLabel?.text = mapSet
        cell.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: cell.textLabel!.font.pointSize)
        
        return cell
    }
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        switch(section) {
        case 0:return "Map Sets"
            
        default :return ""
            
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
        header?.textLabel?.textColor = .black
        
    }
   
}
