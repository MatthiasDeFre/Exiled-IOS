//
//  EventActionFactory.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
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
    private static func change(game : Game, valuesSub : [String]) {
        
    }
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
