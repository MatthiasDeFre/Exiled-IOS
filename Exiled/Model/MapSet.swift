//
//  MapSet.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
class MapSet {
    var map : [[Int]]
    var undiscoveredEvents = [Int : Event]()
    var possibleEvents = [Event]()
    var discoveredEvents = [Int : Event]()
    private var selectedTile : (Int, Int)?
    init() {
        map =
            [[0,1,1,1,1,1],
             [1,1,1,1,1,1],
             [1,1,1,1,1,1],
             [1,1,1,1,1,0],
             [1,1,1,1,0,0]
            ]
    }
    
    func selectTile(from coordinates : (Int, Int)) -> Tile {
        selectedTile = coordinates
        print(coordinates)
        //Return tile info
        return TileDictionary.instance.tileDictionary[map[coordinates.0][coordinates.1]]!
    }
}
