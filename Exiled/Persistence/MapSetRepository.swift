//
//  MapSetRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
struct MapSetRepository {
    let mapSetsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("mapsets", isDirectory: true)
    
    var savedMapSets : [String] {
        get {
            var savedSets = [String]()
            if var files = try? FileManager.default.contentsOfDirectory(at: mapSetsURL, includingPropertiesForKeys: nil) {
                files = files.filter{$0.path.hasSuffix(".json")}
                for var file in files {
                    print(file.lastPathComponent)
                    file.deletePathExtension()
                    savedSets.append(file.lastPathComponent)
                }
            }
            return savedSets
        }
    }
    var directoryExists : Bool {
        get {
            return FileManager.default.fileExists(atPath: mapSetsURL.path)
        }
    }
    func createMapSetDirectory() throws {
        try FileManager.default.createDirectory(at: mapSetsURL, withIntermediateDirectories: true, attributes: nil)
    }
    func createDefaultMapSets() throws{
        let mapSet1 = MapSet(name: "FirstMap")
        let mapSet2 = MapSet(name: "SecondMap")
        try saveMapSet(mapSet: mapSet1)
        try saveMapSet(mapSet: mapSet2)
    }
    func saveMapSet(mapSet : MapSet) throws{
        let jsonEncoder = JSONEncoder.init()
        let jsonData = try jsonEncoder.encode(mapSet)
        let jsonString = String(data: jsonData, encoding: .utf8)
        let savedURL = mapSetsURL.appendingPathComponent(mapSet.name)
            .appendingPathExtension("json")
        print("JSON String : " + jsonString!)
        try jsonString?.write(to: savedURL, atomically: true, encoding: .utf8)
    }
    
}
