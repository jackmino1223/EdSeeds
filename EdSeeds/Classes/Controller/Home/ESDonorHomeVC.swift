//
//  ESDonorHomeVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESDonorHomeVC: ESCampaignsBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCampaigns(keyword: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Home"
    }
    
    // MARK: - from Notification
    func showFromNotification(_ notification: ESNotificationModel) -> Void {
        var index: Int = 0
        
        for campaign in self.campaigns {
            if campaign.cId == notification.targetId {
                let indexPath = IndexPath(row: 0, section: index)
                self.tblCampaignList.scrollToRow(at: indexPath, at: .top, animated: true)
                break
            }
            index += 1
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
