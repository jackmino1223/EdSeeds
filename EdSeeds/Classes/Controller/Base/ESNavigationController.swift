//
//  ESNavigationController.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage = UIImage(named: "img-navigation-background")
        self.navigationBar.setBackgroundImage(bgImage, for: .default)
        
        let iconBackButton = UIImage(named: "iconBackButton")
        self.navigationBar.backIndicatorImage = iconBackButton
        self.navigationBar.backIndicatorTransitionMaskImage = iconBackButton
        self.navigationBar.tintColor = UIColor.white
        
		self.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: ESConstant.FontName.Bold, size: 20)!,
            NSForegroundColorAttributeName : UIColor.white
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
