//
//  ESMainNavController.swift
//  EdSeeds
//
//  Created by BeautiStar on 3/29/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESMainNavController: ESNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ESConstant.Color.ViewBackground
        
        requestManager().requestForAppToken { (result: String?) in
            
            if result == nil {
                let mainTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ESMainTabVC") as! ESMainTabVC
                self.viewControllers = [mainTabVC]
            } else {
                self.showSimpleAlert(title: "Error", message: "You can't connect to server right now. Please contact to support team.", dismissed: {
                    
                })
            }
        }
    }
}
