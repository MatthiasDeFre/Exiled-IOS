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
    let tileDictionary : [TileType: Tile]
    init() {
        tileDictionary = [
            .water : Tile(description: "Water", is: TileType.water),
            .land : Tile(description: "Land", is: TileType.land, upgradesTo: TileType.lumberyard),
            .mine : Building(description: "Mine", is: TileType.mine, gives: 50, of: ResourceType.stone, costs: (50,50,0)),
            .lumberyard : Building(description: "Lumberyard", is: TileType.lumberyard, gives: 50, of: ResourceType.wood, costs: (1000, 10,0)),
            .mint : Building(description: "Mint", is: TileType.mint, gives: 50, of: ResourceType.gold, costs: (20, 100,30)),
        ]
    }
    
    func getTileDescription(tileType : TileType) -> String{
        return tileDictionary[tileType]!.description
    }
}
