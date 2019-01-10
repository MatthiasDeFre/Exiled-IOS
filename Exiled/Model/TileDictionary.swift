//
//  BuildingDictionary.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
struct TileDictionary {
    static let instance = TileDictionary()
    let tileDictionary : [Int: Tile]
    init() {
        tileDictionary = [
            0 : Tile(description: "Water", is: TileType.water),
            1 : Tile(description: "Land", is: TileType.land),
            50 : Building(description: "Mine", is: TileType.mine, gives: 50, of: ResourceType.stone),
            51 : Building(description: "Lumberyard", is: TileType.lumberyard, gives: 50, of: ResourceType.wood),
            52 : Building(description: "Mint", is: TileType.mint, gives: 50, of: ResourceType.gold),
        ]
    }
}
