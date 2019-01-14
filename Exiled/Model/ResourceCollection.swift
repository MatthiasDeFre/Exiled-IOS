//
//  ResourceCollection.swift
//  Exiled
//
//  Created by Matthias De Fré on 14/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
struct ResourceCollection : Codable{
    var wood = 0
    var gold = 0
    var stone = 0
    
    private enum CodingKeys: String, CodingKey {
        case wood
        case gold
        case stone
    }
   
    init() {
        
    }
    init(wood : Int, stone : Int, gold : Int) {
        self.wood = wood
        self.gold = gold
        self.stone = stone
    }
}
extension ResourceCollection {
    static func + (left: ResourceCollection, right: ResourceCollection) -> (ResourceCollection) {
        return ResourceCollection(wood: left.wood + right.wood, stone: left.stone+right.stone, gold: left.gold + right.gold)
    }
    static func - (left: ResourceCollection, right: ResourceCollection) -> (ResourceCollection) {
        return ResourceCollection(wood: left.wood - right.wood, stone: left.stone-right.stone, gold: left.gold - right.gold)
    }
    static func >= (left: ResourceCollection, right: ResourceCollection) -> (Bool) {
        return (left.wood >= right.wood && left.stone >= right.stone && left.gold >= right.gold)
    }
}
