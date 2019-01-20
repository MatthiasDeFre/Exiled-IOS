//
//  BuildingDictionary.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation

//Singleton struct containing all tile definitions
struct TileDictionary {
    static let instance = TileDictionary()
    let tileDictionary : [TileType: Tile]
    init() {
        tileDictionary = [
            .water : Tile(description: "Water", is: TileType.water),
            .land : Tile(description: "Land", is: TileType.land, upgradesTo: TileType.lumberyard),
            .rock : Tile(description: "Rock", is: TileType.rock, upgradesTo: TileType.mine),
            .mine : Building(description: "Mine", is: TileType.mine, gives: 50, of: ResourceType.stone, costs: ResourceCollection(wood: 50,stone: 50,gold: 0)),
            .lumberyard : Building(description: "Lumberyard", is: TileType.lumberyard, gives: 50, of: ResourceType.wood, costs: ResourceCollection(wood: 1000, stone: 10,gold: 0)),
            .mint : Building(description: "Mint", is: TileType.mint, gives: 50, of: ResourceType.gold, costs: ResourceCollection(wood: 20, stone: 100,gold: 30)),
        ]
    }
    
    func getTileDescription(tileType : TileType) -> String{
        return tileDictionary[tileType]!.description
    }
}
