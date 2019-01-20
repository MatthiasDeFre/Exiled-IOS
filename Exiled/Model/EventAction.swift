//
//  EventAction.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Struct containing the logic of an actionChoice of an event
struct EventAction : Codable {
    let description : String
    let value : [String]
    let type : EventActionType
    
    init(description : String, ofType type : EventActionType, withValues values : [String]) {
        self.description = description
        self.value = values
        self.type = type
    }
    
    private enum CodingKeys: String, CodingKey {
        case description
        case value
        case type
    }
    
    func executeAction(game : Game) {
        EventActionFactory.createAction(game: game, values: value, type: type)
    }
}

