//
//  GenericRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
class GenericRepository<Element : Named> {
    var mainDirectory : String!
    var mainURL : URL {
        get {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(mainDirectory, isDirectory: true)
        }
    }
    var savedData : [String] {
        get {
            var saved = [String]()
            if var files = try? FileManager.default.contentsOfDirectory(at: mainURL, includingPropertiesForKeys: nil) {
                files = files.filter{$0.path.hasSuffix(".json")}
                for var file in files {
                    print(file.lastPathComponent)
                    file.deletePathExtension()
                    saved.append(file.lastPathComponent)
                }
            }
            return saved
        }
    }
    
    var directoryExists : Bool {
        get {
            return FileManager.default.fileExists(atPath: mainURL.path)
        }
    }
    
    
    
    func createDirectory() throws {
        try FileManager.default.createDirectory(at: mainURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    func loadData(named name : String) throws -> Element{
        print("name: ", name)
        let loadURL = mainURL.appendingPathComponent(name).appendingPathExtension("json")
        print(loadURL)
        if let loadedData = try? Data(contentsOf: loadURL), let loadedObject = try? JSONDecoder().decode(Element.self, from: loadedData) {
            return loadedObject
        }
        
        throw LoadDataError.runtimeError("Error loading data")
    }
    func saveData(element : Element) throws{
        let jsonEncoder = JSONEncoder.init()
        let jsonData = try jsonEncoder.encode(element)
        let jsonString = String(data: jsonData, encoding: .utf8)
        let fileName = element.name.replacingOccurrences(of: " ", with: "-")
        let savedURL = mainURL.appendingPathComponent(fileName)
            .appendingPathExtension("json")
        print("JSON String : " + jsonString!)
        try jsonString?.write(to: savedURL, atomically: true, encoding: .utf8)
    }
    func removeData(named name: String) throws {
        print("Name: ", name)
        try FileManager.default.removeItem(at:
            mainURL.appendingPathComponent(name)
                .appendingPathExtension("json"))
    }
}
enum LoadDataError: Error {
    case runtimeError(String)
}
protocol Named : Codable {
    var name : String { get }
}
