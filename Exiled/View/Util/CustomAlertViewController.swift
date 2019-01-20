//
//  CustomAlertViewController.swift
//  Exiled
//
//  Created by Matthias De Fré on 19/01/2019.
//  Copyright © 2019 Matthias De Fré. All rights reserved.
//

import UIKit

//Custom alertviewController class used to set UI elements to custom backgrounds and fonts
class CustomAlertViewController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(patternImage: UIImage(named: "background")!).withAlphaComponent(0.75)
        self.view.subviews.first?.subviews.first?.subviews.first?.isOpaque = true
        let actionView = self.view.subviews.first?.subviews.first?.subviews.first?.subviews.last
        actionView?.backgroundColor = UIColor(patternImage: UIImage(named: "savegameline")!)
        
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "OptimusPrincepsSemiBold", size: 22.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "OptimusPrinceps", size: 18.0)!]
        let titleAttrString = NSMutableAttributedString(string: self.title ?? "Default Title", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: self.message ?? "Default Message", attributes: messageFont)
        
    
        
        setValue(titleAttrString, forKey: "attributedTitle")
        setValue(messageAttrString, forKey: "attributedMessage")
       
       
    }
    

}

