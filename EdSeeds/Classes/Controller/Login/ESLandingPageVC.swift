//
//  ESLandingPageVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESLandingPageVC: ESCampaignsBaseVC {
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var viewLogoContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewLogoContainer.layer.shadowColor = UIColor.gray.cgColor
        viewLogoContainer.layer.shadowOffset = CGSize(width: 1, height: 5)
        viewLogoContainer.layer.shadowRadius = 5
        viewLogoContainer.layer.shadowOpacity = 0.8
        
        btnSignIn.makeRound()
        btnJoin.makeRound()
        
        loadCampaigns(keyword: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
