//
//  EventActionFactory.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Struct containing static functions to create an Action
struct EventActionFactory {
    static func createAction(game : Game, values : [String], type: EventActionType) {
        let callback : (Game, [String]) -> ()
        let amountPerIteration : Int
        switch type {
        case .change:
            amountPerIteration = 3
            callback = change
            break
        case .loseR:
            amountPerIteration = 2
            callback = lose
            break
        case .winR:
            amountPerIteration = 2
            callback = win
            break
        }
     
        let sequence = stride(from: 0, to: values.count, by: amountPerIteration)
     
        print("Event doing")
        for i in sequence {
            print(i)
            callback(game, Array(values[i..<i+amountPerIteration]))
        }
    }
    /*
     Change the game map depending on the values
     Value 0 => Tiletype that will be changed
     Value 1 => Tiletype that Value 0 will change to
     Value 2 => Amount of tiles that will be changed or 'all' to change all tiles
     */
    private static func change(game : Game, valuesSub : [String]) {
          let fromType = TileType(rawValue: valuesSub[0].capitalized)!
          let toType = TileType(rawValue: valuesSub[1].capitalized)!
          let amountString = valuesSub[2].lowercased()
        var amount = 0
        if amountString != "all" {
            amount = Int(amountString)!
        }
        var currentAmount = 1
        
        print("A",amount)
        for (i, row) in game.mapSet.map.enumerated() {
            for (j, col) in row.enumerated() {
                if((currentAmount <= amount || amountString == "all") && col == fromType) {
                    game.mapSet.map[i][j] = toType
                    print("CURRENT",currentAmount)
                    currentAmount += 1
                }
            }
        }
    }
    /*
     Method to lose a resource
     Value 0 => ResourceType
     Value 1 => Amount to lose
     */
    private static func lose(game : Game, valuesSub : [String]) {
        let resourceType = ResourceType(rawValue: valuesSub[0].lowercased())!
        print(valuesSub)
        switch(resourceType) {
        case .wood:
            game.resources.wood -= Int(valuesSub[1])!
            break
        case .gold:
             game.resources.gold -=  Int(valuesSub[1])!
            break
        case .stone:
             game.resources.stone -=  Int(valuesSub[1])!
            break
        
    }
    }
    /*
     Method to gain a resource
     Value 0 => ResourceType
     Value 1 => Amount to gain
     */
    private static func win(game : Game, valuesSub : [String]) {
        let resourceType = ResourceType(rawValue: valuesSub[0].lowercased())!
        switch(resourceType) {
        case .wood:
            game.resources.wood += Int(valuesSub[1])!
            break
        case .gold:
            game.resources.gold +=  Int(valuesSub[1])!
            break
        case .stone:
            game.resources.stone +=  Int(valuesSub[1])!
            break
    }
        }
}
