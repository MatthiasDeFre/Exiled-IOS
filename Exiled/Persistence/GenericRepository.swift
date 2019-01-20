//
//  GenericRepository.swift
//  Exiled
//
//  Created by Matthias De Fré on 18/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import Foundation
//Generic implementation for any class implementing the Named protocol
class GenericRepository<Element : Named> {
    
    //String to determine where the objects should be saved to
    var mainDirectory : String!
    
    //URL used to determine the complete path where the objects should be saved to
    var mainURL : URL {
        get {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(mainDirectory, isDirectory: true)
        }
    }
    
    //Array of Strings containing all the saved objects of the given type in the given directory
    var savedData : [String] {
        get {
            var saved = [String]()
            if var files = try? FileManager.default.contentsOfDirectory(at: mainURL, includingPropertiesForKeys: nil) {
                files = files.filter{$0.path.hasSuffix(".json")}
                for var file in files {
                    print(file.lastPathComponent)
                    file.deletePathExtension()
                    let fileWithSpace = file.lastPathComponent.replacingOccurrences(of: "-", with: " ")
                    saved.append(fileWithSpace)
                }
            }
            return saved
        }
    }
    
    //Method to check if directory exists
    var directoryExists : Bool {
        get {
            return FileManager.default.fileExists(atPath: mainURL.path)
        }
    }
    
    
    /*Method to create the directory
     This method will still work even if the given directory already exists
    */
    func createDirectory() throws {
        try FileManager.default.createDirectory(at: mainURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    //Method to load the data in the given directory with the given name
    func loadData(named name : String) throws -> Element{
        print("name: ", name)
        let fileName = name.replacingOccurrences(of: " ", with: "-")
        let loadURL = mainURL.appendingPathComponent(fileName).appendingPathExtension("json")
        print(loadURL)
        if let loadedData = try? Data(contentsOf: loadURL), let loadedObject = try? JSONDecoder().decode(Element.self, from: loadedData) {
            return loadedObject
        }
        
        throw LoadDataError.runtimeError("Error loading data")
    }
    
     //Method to save the data into the given directory
    func saveData(element : Element) throws{
        let jsonEncoder = JSONEncoder.init()
        let jsonData = try jsonEncoder.encode(element)
        let jsonString = String(data: jsonData, encoding: .utf8)
        let fileName = element.name.replacingOccurrences(of: " ", with: "-")
        print("Filename", fileName)
        let savedURL = mainURL.appendingPathComponent(fileName)
            .appendingPathExtension("json")
        print("JSON String : " + jsonString!)
        try jsonString?.write(to: savedURL, atomically: true, encoding: .utf8)
    }
    
    //Method to remove the data from the given directory with the given name
    func removeData(named name: String) throws {
        print("Name: ", name)
        try FileManager.default.removeItem(at:
            mainURL.appendingPathComponent(name)
                .appendingPathExtension("json"))
    }
}
//In case of error => throw this
enum LoadDataError: Error {
    case runtimeError(String)
}
//Protocol used by the generic repository to save 
protocol Named : Codable {
    var name : String { get }
}
