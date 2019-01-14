//
//  Game.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Wood, Stone, Gold
typealias ResourceCollection = (Int,Int,Int)
class Game {
    var mapSet : MapSet = MapSet()
    var resources : ResourceCollection
    var resourcesPerTurn : ResourceCollection {
        return mapSet.resourcesPerTurn
    }
    
    init() {
        resources = (1000,1000,1000)
    }
    func canUpgrade() -> Bool {
        let upgrade = mapSet.selectedTileUpgrade
        if let upgrade = upgrade {
            if let building = upgrade as? Building {
                return resources >= building.resourceCost
            }
        }
        return false
    }
    func nextTurn() {
        resources = resources + resourcesPerTurn
        
    }
    func upgradeSelectedBuilding() -> ((Int, Int), TileType){
        self.resources = resources - (mapSet.selectedTileUpgrade! as! Building).resourceCost
        return mapSet.upgradeSelectedTile()
    }
    
   
}
func + (left: (Int,Int,Int), right: (Int, Int,Int)) -> (ResourceCollection) {
    return (left.0 + right.0, left.1+right.1, left.2 + right.2)
}
func - (left: (Int,Int,Int), right: (Int, Int,Int)) -> (ResourceCollection) {
    return (left.0 - right.0, left.1-right.1, left.2 - right.2)
}


