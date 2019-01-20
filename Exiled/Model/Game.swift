//
//  Game.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Wood, Stone, Gold

//Class housing all domain logic for the game
class Game : Named{
    var name : String
    var mapSet : MapSet
    var resources : ResourceCollection
    
    var resourcesPerTurn : ResourceCollection {
        return mapSet.resourcesPerTurn
    }
    
    //Return gamestatus
    var gameStatus : GameStatus {
        get {
            if resources <= -1000 {
                return .lost
            } else if mapSet.possibleEvents.isEmpty{
                return .won
            }
            return .normal
        }
    }
    private enum CodingKeys: String, CodingKey {
        case name
        case mapSet
        case resources
    }
    init(isCalled gameName : String, mapSet : MapSet) {
        self.name = gameName
        self.mapSet = mapSet
        resources = ResourceCollection(wood: 1000,stone: 1000,gold: 1000)
    }
   
    //Is the selectedTile upgradable
    func canUpgrade() -> Bool {
        let upgrade = mapSet.selectedTileUpgrade
        if let upgrade = upgrade {
            if let building = upgrade as? Building {
                return resources >= building.resourceCost
            }
        }
        return false
    }
    
    //Go to the next turn and return the event if there is one
    func nextTurn() -> Event? {
        resources = resources + resourcesPerTurn
        if let event = mapSet.nextEvent() {
            print("Event done")
            event.executeEvent(game: self)
            return event
        }
        return nil
        
    }
    
    //Upgrade the selected building
    func upgradeSelectedBuilding() -> ((Int, Int), TileType){
        self.resources = resources - (mapSet.selectedTileUpgrade! as! Building).resourceCost
        return mapSet.upgradeSelectedTile()
    }
    
    
}
enum GameStatus : Int {
    case normal = 0
    case won = 1
    case lost = 2
}



