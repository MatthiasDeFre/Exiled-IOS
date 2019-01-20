//
//  SaveGameRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Repository implementation for the SaveGame class
class SaveGameRepository : GenericRepository<Game>  {
    
    override init() {
        super.init()
        mainDirectory = "savegames"
    }
}
