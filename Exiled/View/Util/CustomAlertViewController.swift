//
//  CustomAlertViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 19/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(patternImage: UIImage(named: "background")!).withAlphaComponent(0.75)
        self.view.subviews.first?.subviews.first?.subviews.first?.isOpaque = true
        let actionView = self.view.subviews.first?.subviews.first?.subviews.first?.subviews.last
        actionView?.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
    }
    

}
