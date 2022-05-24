//
//  ESTopBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/25/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import PTPopupWebView

class ESTopBaseVC: ESViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabVC = self.tabBarController {
            tabVC.navigationItem.title = viewControllerTitle()
            if let rightButtonTittle = navigationRightButtonTitle() {
                
                let rightButton = UIBarButtonItem(title: rightButtonTittle, style: .plain, target: self, action: #selector(onPressNavigationRightButton(_:)))
                tabVC.navigationItem.rightBarButtonItem = rightButton
                
            } else {
                tabVC.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabVC = self.tabBarController {
            tabVC.navigationItem.title = " "
        }
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
