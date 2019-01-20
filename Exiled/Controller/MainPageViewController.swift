//
//  MainPageViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 19/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

//Change UI element of navigation view
class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:  UIFont(name: "OptimusPrincepsSemiBold", size: 20)!]
         self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "background")!)
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OptimusPrincepsSemiBold", size: 20)!], for: UIControl.State.normal)
        navigationItem.backBarButtonItem = backButton
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    

    

}
