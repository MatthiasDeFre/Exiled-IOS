//
//  MapSetRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
class MapSetRepository : GenericRepository<MapSet> {
   
    let baseURL = URL(string: "http://localhost:3000/games/")
    
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
    
    func fetchMapSetNames(completion: @escaping ([String]?)-> Void) {
      
        
        let task = URLSession.shared.dataTask(with: baseURL!) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
        
            if let data = data,
                let mapSetNames = try?
                    jsonDecoder.decode([String].self, from: data) {
                completion(mapSetNames)
            } else {
                completion(nil)
            }
        }
        task.resume()
        
    }
    func fetchSingleMap(completion: @escaping (String?)-> Void, name: String) {
        
        let url = baseURL?.appendingPathComponent(name)
        let task = URLSession.shared.dataTask(with: url!) { (data,
            response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data,
                let mapSet = try?
                    jsonDecoder.decode(MapSet.self, from: data) {
                if let _ = try? self.saveData(element: mapSet) {
                    completion(mapSet.name)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
        
    }
    
}
