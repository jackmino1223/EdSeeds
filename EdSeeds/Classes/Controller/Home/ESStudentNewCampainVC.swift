//
//  ESStudentNewCampainVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import DatePickerDialog
import MBProgressHUD

class ESStudentNewCampainVC: ESVideoSelectBaseVC {

    @IBOutlet weak var txtMoney: ESTextField!
    @IBOutlet weak var txtDate: ESTextField!
    
    
    fileprivate var isEditingMode: Bool = false
    fileprivate var originalCampaign: ESCampaignModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        txtMoney.makeBorder(width: 1, color: borderColor)
        txtDate.makeBorder(width: 1, color: borderColor)
        
        let imgDollar = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imgDollar.contentMode = .center
        imgDollar.image = UIImage(named: "iconDollar")
        txtMoney.leftView = imgDollar
        txtMoney.leftViewMode = .always
        
        if isEditingMode {
            showOriginalCampaignInformation(self.originalCampaign!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        if isEditingMode {
            return "Edit Campaign"
        } else {
            return "Start a new Campaign"
        }
    }

    func setEditingMode(originalCampaign campaign: ESCampaignModel) -> Void {
        isEditingMode = true
        self.originalCampaign = campaign
    }
    
    fileprivate func showOriginalCampaignInformation(_ campaign: ESCampaignModel) {
        txtTitle.text = campaign.campaignName
        txtDescription.text = campaign.details
        txtMoney.text = String(campaign.totalNeeds)
        txtDate.text = campaign.dueDate
        
        btnCreateCampain.setTitle("Save", for: .normal)

    }
    
    override func submit() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let completeClosure = { (errorMessage: String?) in
            
            if errorMessage == nil {
                
                _ = self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                object: nil, userInfo: nil)
                
            } else {
                self.showSimpleAlert(title: NSLocalizedString("Error", comment: ""),
                                     message: errorMessage, dismissed: nil)
            }
            
            //                                            self.stopLoadingIndicator()
            hud.hide(animated: true)
            
        }
        
        if isEditingMode {
            if selectedVideoURL != nil {
                hud.mode = .determinateHorizontalBar
                hud.label.text = "Uploading Video..."
            } else {
                hud.label.text = "Updating campaign"
            }
            
            let money = Double(txtMoney.text!)!
            requestManager().editCampaign(user: appManager().currentUser!,
                                          campaignId: originalCampaign!.cId,
                                          totalNeeds: money,
                                          dueDate: txtDate.text!,
                                          name: txtTitle.text!,
                                          details: txtDescription.text,
                                          video: selectedVideoURL,
                                          progress: { progress in
                                            hud.progressObject = progress
            },
                                          complete: completeClosure)
            
            
        } else {
            if selectedVideoURL != nil {
                hud.mode = .determinateHorizontalBar
                
                hud.label.text = "Uploading Video"
            } else {
                hud.label.text = "Creating new campaign"
            }
            let money = Double(txtMoney.text!)!
            requestManager().addCampaign(user: appManager().currentUser!,
                                         totalNeeds: money,
                                         dueDate: txtDate.text!,
                                         name: txtTitle.text!,
                                         details: txtDescription.text,
                                         video: selectedVideoURL,
                                         progress: { progress in
                                            hud.progressObject = progress
            },
                                         complete: completeClosure)
        }

    }
    
    
    override func availableCampaignInfo() -> Bool {
        var isAvailable = super.availableCampaignInfo()
        
        let redBorderColor = UIColor.red
        if txtDescription.text.characters.count == 0 {
            txtDescription.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        let money = Double(txtMoney.text!)
        if money == nil {
            txtMoney.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        } else {
            if money! < 100 || money! > 100000 {
                txtMoney.makeBorder(width: 1, color: redBorderColor)
                isAvailable = false
            }
        }
        
        if txtDate.text?.characters.count == 0 {
            txtDate.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        
        return isAvailable
    }
    
    // MARK: - UITextField delegate
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMoney {
            txtDate.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDate {
            DatePickerDialog().show(title: NSLocalizedString("Select Date", comment: ""),
                                    doneButtonTitle: NSLocalizedString("Select", comment: ""),
                                    cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                    datePickerMode: .date) { (date) -> Void in
                                        if date != nil {
                                            let remainDays = ESAppManager.calculateDaysBetweenTwoDates(start: Date(), end: date!)
                                            if 0 < remainDays && remainDays <= 31 {
                                                self.txtDate.text = ESConstant.ESDateFormatter.OnlyDate.string(from: date!)
                                            } else {
                                                self.showSimpleAlert(title: "Error", message: "Please select due date less than a month.", dismissed: nil)
                                            }
                                        }
            }
            return false
        } else {
            return true
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
