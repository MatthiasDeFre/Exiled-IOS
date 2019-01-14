//
//  MapSet.swift
//  Exiled
//
//  Created by Matthias De Fré on .land.water/.water.land/2.water.land9.
//  Copyright © 2.water.land9 Matthias De Fré. All rights reserved.
//

import Foundation
class MapSet {
    var map : [[TileType]]
    var undiscoveredEvents = [Int : Event]()
    var possibleEvents = [Event]()
    var discoveredEvents = [Int : Event]()
    var tileDictionary = TileDictionary.instance.tileDictionary
    
    var resourcesPerTurn : ResourceCollection {
        get {
           
            var gold = 0
            var wood = 0
            var stone = 0
           
            for row in map {
                for column in row {
                    if let building = tileDictionary[column]
                        as? Building {
                    
                        switch(building.resourceType) {
                        case .gold:
                                gold += building.value
                                break;
                        case .wood:
                                wood += building.value
                                break;
                        case .stone:
                                stone += building.value
                                break;
                        }
                    }
                }
                
            }
                print("wood",wood)
            let resourceCollection = (wood, stone, gold)
            return resourceCollection
        }
    }
    
    private var selectedTile : (Int, Int)!
    var selectedTileUpgrade : Tile? {
        get {
            if let upgrade = tileDictionary[map[selectedTile.0][selectedTile.1]]!.upgrade {
                return tileDictionary[upgrade]
            }
            return nil
        }
    }
    
    init() {
        map =
            [[.water,.land,.land,.land,.land,.land],
             [.land,.land,.land,.land,.land,.land],
             [.land,.land,.land,.land,.land,.land],
             [.land,.land,.land,.land,.land,.water],
             [.land,.land,.land,.land,.water,.water]
            ]
    }
    
    func selectTile(from coordinates : (Int, Int)) -> Tile {
        selectedTile = coordinates
        print(coordinates)
        //Return tile info
        return tileDictionary[map[coordinates.0][coordinates.1]]!
    }
    func upgradeSelectedTile() -> ((Int, Int), TileType){
        if let selectedTile = selectedTile {
           let tile = tileDictionary[map[selectedTile.0][selectedTile.1]]!
           let upgrade = tileDictionary[tile.upgrade!]!.tileType
           map[selectedTile.0][selectedTile.1] = upgrade
        }
        return ((selectedTile!), map[selectedTile!.0][selectedTile!.1])
    }
}
