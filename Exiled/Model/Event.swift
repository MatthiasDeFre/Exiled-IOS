//
//  Event.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Struct containing the event logic
//An event can have actions these actions are options the player can choose to affect his game
struct Event : Codable, Equatable {
    let id : Int
    let type : EventActionType
    let values : [String]
    let title : String
    let description : String
    let successorsIds : [Int]
    let actions : [EventAction]
    
    init(eventId : Int, isType type : EventActionType, using : [String], titled : String, description : String, isFollowedBy successorsIds : [Int] = [Int](), hasActions actions : [EventAction] = [EventAction]()) {
        self.id = eventId
        self.type = type
        self.values = using
        self.title = titled
        self.description = description
        self.successorsIds = successorsIds
        self.actions = actions
    }
    
    //Get the action from the factory which will execute it
    func executeEvent(game : Game) {
        EventActionFactory.createAction(game: game, values: values, type: type)
    }
    
    //Operator functions
    static func !== (event1 : Event, event2 : Event) -> Bool{
        return event1.id != event2.id
    }
    static func == (event1 : Event, event2 : Event) -> Bool {
        return event1.id == event2.id
    }
}
