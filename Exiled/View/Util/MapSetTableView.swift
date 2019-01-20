//
//  MapSetTableView.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
import UIKit

//Custom tableview datasource and delegate class which will handle all tableview actions
class MapSetTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    var mapSets = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mapSets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapSet", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        let mapSet = mapSets[indexPath.row]
        cell.textLabel?.text = mapSet
          cell.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: cell.textLabel!.font.pointSize)
        return cell
    }
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        switch(section) {
        case 0:return "Map Sets"
       
        default :return ""
            
        }
    }
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        
        header?.textLabel?.font = UIFont(name: "OptimusPrincepsSemiBold", size: 20)
        header?.textLabel?.textColor = .black
        
    }
}
