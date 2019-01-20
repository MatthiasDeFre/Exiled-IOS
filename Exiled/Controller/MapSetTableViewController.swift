//
//  MapSetTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class MapSetTableViewController: UITableViewController {

    /*
     Array containing a String, Bool tuple
     String => Name of MapSet
     Bool => True if the file has been downloaded, False if the file has not been downloaded
    */
    var mapSets = [(String, Bool)]()
    
    //MapSetRepository instance
    let mapSetRepo = MapSetRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if the directory exists and create it if it doesn't
        if(!mapSetRepo.directoryExists) {
            do {
                try mapSetRepo.createDirectory()
            } catch {
                print(error)
            }
        }
        //Try to create the default mapsets
        try! mapSetRepo.createDefaultMapSets()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //Add all the saved maps to the tableview
        for map in mapSetRepo.savedData {
             mapSets.append((map,true))
        }
      
    }

    override func viewDidAppear(_ animated: Bool) {
        //Fetch all the mapset names from the backend and update the table
        mapSetRepo.fetchMapSetNames { (mapSetNames) in
            self.updateTable(with: mapSetNames)
        }
    }

    
    //Tableview Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return mapSets.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapSet", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        let mapSet = mapSets[indexPath.row]
        cell.textLabel?.text = mapSet.0
        cell.imageView?.image = UIImage(named: mapSet.1 ? "downloaded" : "notdownloaded")
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
        //Change header font
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
        header?.textLabel?.textColor = .black
        
    }
    
    //If the clicked cell = not downloaded = download the clicked cell and update tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if mapSets[indexPath.row].1 == false {
            mapSetRepo.fetchSingleMap(completion: { (mapSetName) in
                self.updateSingleCell(with: mapSetName)
            }, name: mapSets[indexPath.row].0)
        }
    
    }
    
    //Only allowed downloaded cells to be deleted
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) ->
        UITableViewCell.EditingStyle {
            if mapSets[indexPath.row].1 {
                return .delete
            }
            return .none
    }
    
    //Delete file from directory and set status to not downloaded
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            
            do {
                
                try mapSetRepo.removeData(named: mapSets[indexPath.row].0)
                mapSets[indexPath.row] = (mapSets[indexPath.row].0, false)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    //Update table with the given names
    func updateTable(with mapSetNames : [String]?) {
        if let mapSetNames = mapSetNames {
            for map in mapSetNames {
                if !mapSets.contains(where: {$0.0 == map}) {
                      mapSets.append((map, false))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }
    
    //Update a single cell if the mapset name is not nil
    func updateSingleCell(with mapSetName : String?) {
        guard let mapSetName = mapSetName else {
            return
        }
        if let i = mapSets.index(where: {$0.0 == mapSetName}) {
            mapSets[i] = (mapSetName, true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}
