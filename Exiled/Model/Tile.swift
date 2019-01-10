//
//  Tile.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
class Tile {
    var description : String
    var tileType : TileType
    init(description : String, is tileType : TileType) {
        self.description = description
        self.tileType = tileType
    }
}
