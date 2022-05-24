//
//  ESStudentAddNewVideoVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/15/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import MBProgressHUD

class ESStudentAddNewVideoVC: ESVideoSelectBaseVC {

    var campaign: ESCampaignModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Add Video"
    }
    
    override func submit() {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.mode = .determinateHorizontalBar
        hud.label.text = "Uploading Video..."

        requestManager().uploadVideo(user: appManager().currentUser!,
                                     campaignId: campaign.cId,
                                     title: self.txtTitle.text!,
                                     videoDescription: self.txtDescription.text,
                                     videoURL: selectedVideoURL!, progress: { (progress: Progress) in
            
            hud.progressObject = progress
            
        }) { (videoPath: String?, errorMessage: String?) in
            if videoPath != nil {
                
                let video = ESVideoModel(title: self.txtTitle.text, description: self.txtDescription.text, videoPath: videoPath!)
                self.campaign.videos?.append(video)
                
                _ = self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.AddedNewVideo),
                                                object: nil, userInfo: nil)
                
            } else {
                self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
            }
            hud.hide(animated: true)

        }
        
    }
    
    override func availableCampaignInfo() -> Bool {
        var isAvailable = super.availableCampaignInfo()
        
        if selectedVideoURL == nil {
            isAvailable = false
            self.showSimpleAlert(title: "Warning", message: "You didn't select video. Please select or capture your video.", dismissed: nil)
        }
        
        return isAvailable
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
