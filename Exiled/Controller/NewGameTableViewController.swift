//
//  NewGameTableViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 17/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class NewGameTableViewController: UITableViewController {
    
    
    @IBOutlet weak var txtGameName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let game = Game(isCalled: txtGameName.text!)
        let gameViewController = segue.destination as! GameViewController
        let jsonEncoder = JSONEncoder()
        do {
            
            let jsonData = try jsonEncoder.encode(game)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            let documentsDirectory =
                FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask).first!
            let archiveURL =
                documentsDirectory.appendingPathComponent("savegames", isDirectory: true).appendingPathComponent(game.gameName)
                    .appendingPathExtension("json")
            try jsonString?.write(to: archiveURL, atomically: true, encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
        }
        gameViewController.game = game;
    }

   

}
