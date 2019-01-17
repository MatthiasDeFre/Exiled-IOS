//
//  Game.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Wood, Stone, Gold

class Game : Codable{
    var gameName : String
    var mapSet : MapSet = MapSet()
    var resources : ResourceCollection
    var resourcesPerTurn : ResourceCollection {
        return mapSet.resourcesPerTurn
    }
    private enum CodingKeys: String, CodingKey {
        case gameName
        case mapSet
        case resources
    }
    init(isCalled gameName : String) {
        self.gameName = gameName
        resources = ResourceCollection(wood: 1000,stone: 1000,gold: 1000)
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



