//
//  MapSetRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
class MapSetRepository : GenericRepository<MapSet> {
   
    override init() {
        super.init()
        mainDirectory = "mapsets"
    }
   
    func createDefaultMapSets() throws{
        let mapSet1 = MapSet(name: "FirstMap")
        let mapSet2 = MapSet(name: "SecondMap")
        let mapSet3 = MapSet(name: "ThirdMap")
        mapSet3.map = [[.water, .water, .water,
                       ],
                       [.lumberyard, .lumberyard, .lumberyard],
                    [.land, .land, .land]]
        try saveData(element: mapSet1)
        try saveData(element: mapSet2)
        try saveData(element: mapSet3)
    }
    
}
