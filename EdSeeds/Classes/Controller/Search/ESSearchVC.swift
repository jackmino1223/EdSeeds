//
//  ESSearchVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESSearchVC: ESCampaignsBaseVC {

    @IBOutlet weak var txtSearchText: ESTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var constraintBottomSpaceForTextField: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        txtSearchText.makeBorder(width: 1, color: borderColor)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCampaign(_:)),
                                               name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                               object: nil)

    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                  object: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Search"
    }
    
    @IBAction func onPressSearch(_ sender: Any) {
        _ = textFieldShouldReturn(txtSearchText)
    }
    
    func reloadCampaign(_ sender: Any) -> Void {
        if txtSearchText.text!.characters.count > 0 {
            loadCampaigns(keyword: txtSearchText.text!)
        }
    }
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearchText {
            if txtSearchText.text!.characters.count > 0 {
                loadCampaigns(keyword: txtSearchText.text!)
            }
            txtSearchText.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Keyboard show, hide
    override func keyboardWillShowRect(_ keyboardSize: CGSize) {
        constraintBottomSpaceForTextField.constant = keyboardSize.height - 49
        updateConstraintWithAnimate()
    }
    
    override func keyboardWillHideRect() {
        constraintBottomSpaceForTextField.constant = 0
        updateConstraintWithAnimate()
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
