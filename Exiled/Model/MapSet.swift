//
//  MapSet.swift
//  Exiled
//
//  Created by Matthias De Fré on .land.water/.water.land/2.water.land9.
//  Copyright © 2.water.land9 Matthias De Fré. All rights reserved.
//

import Foundation

//Class containing all logic affected by the map
class MapSet : Named {
    var name : String
    var map : [[TileType]]
    var undiscoveredEvents = [Int : Event]()
    var possibleEvents = [Event]()
    var completedEvents = [Event]()
    var tileDictionary = TileDictionary.instance.tileDictionary
    
    //Calculate the resources per turn
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
            let resourceCollection = ResourceCollection(wood: wood, stone: stone, gold: gold)
            return resourceCollection
        }
    }
    
    private var selectedTile : (Int, Int)!
    var selectedTileUpgrade : Tile? {
        get {
            guard let selectedTile = selectedTile else {
                return nil
            }
            if let upgrade = tileDictionary[map[selectedTile.0][selectedTile.1]]!.upgrade {
                return tileDictionary[upgrade]
            }
            return nil
        }
    }
    private enum CodingKeys: String, CodingKey {
        case map
        case name
        case undiscoveredEvents
        case possibleEvents
        case completedEvents
    }
    
    //Standard mapSet constructor => Used to create the default mapSets
    init(name : String) {
        map =
            [[.water,.land,.land,.land,.land,.land],
             [.land,.land,.land,.rock,.land,.land],
             [.land,.land,.rock,.rock,.land,.land],
             [.land,.land,.land,.land,.land,.water],
             [.land,.land,.land,.land,.water,.water]
            ]
        possibleEvents.append(Event(eventId: 1, isType: .winR, using: ["W", "500"], titled: "Wood Festival", description: "Due to wood festival you will need to trade either gold or stone with other cities. Gain 500 but lose 500 of the chosen material", isFollowedBy: [2,3], hasActions: [EventAction(description: "Lose Gold", ofType: .loseR, withValues: ["G","1000"]),EventAction(description: "Lose Stone", ofType: .loseR, withValues: ["S","1000"])]))
        undiscoveredEvents[2] = Event(eventId: 2, isType: .winR, using: ["W", "500"], titled: "Test sedcond event", description: "sfddsfsddfsfd")
        self.name = name
    }
   
    //Method to select a tile
    func selectTile(from coordinates : (Int, Int)) -> Tile {
        selectedTile = coordinates
        print(coordinates)
        //Return tile info
        return tileDictionary[map[coordinates.0][coordinates.1]]!
    }
    
    //Method to upgrade a selected tile
    func upgradeSelectedTile() -> ((Int, Int), TileType){
        if let selectedTile = selectedTile {
           let tile = tileDictionary[map[selectedTile.0][selectedTile.1]]!
           let upgrade = tileDictionary[tile.upgrade!]!.tileType
           map[selectedTile.0][selectedTile.1] = upgrade
        }
        return ((selectedTile!), map[selectedTile!.0][selectedTile!.1])
    }
    
    //Method to return the next event if there is one, also adding the successors of the current event
    func nextEvent() -> Event? {
        if let event = possibleEvents.randomElement() {
            for eventId in event.successorsIds {
                if let successorEvent = undiscoveredEvents.removeValue(forKey: eventId) {
                    possibleEvents.append(successorEvent)
                }
            }
            possibleEvents = possibleEvents.filter {$0 !== event}
            completedEvents.append(event)
            return event
        }
        return nil
    }
}
