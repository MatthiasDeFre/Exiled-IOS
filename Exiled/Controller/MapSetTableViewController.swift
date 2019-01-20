//
//  MapSetTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class MapSetTableViewController: UITableViewController {

    var mapSets = [(String, Bool)]()
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
        for map in mapSetRepo.savedData {
             mapSets.append((map,true))
        }
      
    }

    override func viewDidAppear(_ animated: Bool) {
        mapSetRepo.fetchMapSetNames { (mapSetNames) in
            self.updateTable(with: mapSetNames)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
        header?.textLabel?.textColor = .black
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(mapSets[indexPath.row])
        if mapSets[indexPath.row].1 == false {
            mapSetRepo.fetchSingleMap(completion: { (mapSetName) in
                self.updateSingleCell(with: mapSetName)
            }, name: mapSets[indexPath.row].0)
        }
    
    }
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) ->
        UITableViewCell.EditingStyle {
            if mapSets[indexPath.row].1 {
                return .delete
            }
            return .none
    }
    
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
