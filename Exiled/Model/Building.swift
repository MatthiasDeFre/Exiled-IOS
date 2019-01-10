//
//  Building.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation

class Building : Tile {
    var resourceType : ResourceType
    var value : Int
 
    init(description: String, is tileType : TileType, gives amount: Int, of resource : ResourceType ) {
        resourceType = resource
        value = amount
        
        super.init(description: description, is: tileType)
        building = true
    }
}
