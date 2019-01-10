//
//  Event.swift
//  Exiled
//
//  Created by Matthias De Fré on 10/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
struct Event {
    let id : Int
    let type : EventType
    let value : Int
    let description : String
    let successorsIds : [Int]
}
