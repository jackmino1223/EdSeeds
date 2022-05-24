//
//  ESViewController.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MBProgressHUD

class ESViewController: UIViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.backItem?.title = " "
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

//        self.navigationController?.navigationBar.backItem?.title = " "
        navigationItem.title = viewControllerTitle()
        view.backgroundColor = ESConstant.Color.ViewBackground
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }

    func showLoadingIndicator() -> Void {
        startAnimating(nil, message: nil, type: .ballPulseSync, color: UIColor.white, padding: 0, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    func stopLoadingIndicator() -> Void {
        stopAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) -> Void {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShowRect(keyboardSize.size)
            //            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            // ...
        }
        //        var keyboardBound : CGRect = CGRect.zero
        //        (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).getValue(&keyboardBound)
        //        keyboardWillShowRect(keyboardBound.size)
    }
    
    func keyboardWillHide(_ notification: NSNotification) -> Void {
        keyboardWillHideRect()
    }
    
    func keyboardWillShowRect(_ keyboardSize : CGSize) -> Void {
        
    }
    
    func keyboardWillHideRect() -> Void {
        
    }
    

}

extension UIViewController {
    func viewControllerTitle() -> String? {
        return nil
    }
    
    func navigationRightButtonTitle() -> String? {
        return nil
    }
    
    func onPressNavigationRightButton(_ button: UIBarButtonItem) -> Void {
        
    }
    
    func showSimpleAlert(title: String?, message: String?, dismissed: (() -> Void)?) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action: UIAlertAction) in
            if dismissed != nil {
                dismissed!()
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func showAlert(title: String?, message: String?, okButtonTitle: String, cancelButtonTitle: String, okClosure: (() -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let yesAction = UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction) in
            
            if okClosure != nil {
                okClosure!()
            }
        })
        let noAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action: UIAlertAction) in
            
        })
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    func requestManager() -> ESRequestManager {
        return ESRequestManager.sharedManager
    }
    
    func appManager() -> ESAppManager {
        return ESAppManager.sharedManager
    }
    
    func updateConstraintWithAnimate(_ animate: Bool = true) -> Void {
        if animate == true {
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (complete) in
                
            })
        } else {
            updateViewConstraints()
        }
    }

    internal func showProfile(campaign: ESCampaignModel) -> Void {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ESStudentProfilePreviewVC") as! ESStudentProfilePreviewVC
        profileVC.campaign = campaign
        
        if appManager().currentUser != nil {
            self.tabBarController?.navigationController?.pushViewController(profileVC, animated: true)
        } else {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
    }
    
    internal func showEndrosement(campaign: ESCampaignModel) -> Void {
        let endrosementVC = self.storyboard?.instantiateViewController(withIdentifier: "ESEndrosementVC") as! ESEndrosementVC
        endrosementVC.userCampaign = campaign
        if let tabVC = self.tabBarController {
            tabVC.navigationController?.pushViewController(endrosementVC, animated: true)
        } else {
            self.navigationController?.pushViewController(endrosementVC, animated: true)
        }
    }
    
    internal func showShare(campaign: ESCampaignModel) -> Void {
        // text to share
        let text = "This is EdSeed student's profile"
        let url  = requestManager().getPublicProfileLink(studentId: campaign.uId)
        
        // set up activity view controller
        let textToShare: [Any] = [ text, url ?? "" ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ .airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    internal func showSeedScreen(campaign: ESCampaignModel) -> Void {
        /*
         let url = requestManager().getSeedUrl(user: appManager().currentUser!, studentId: campaign.uId)
         
         let style = PTPopupWebViewControllerStyle()
         .titleBackgroundColor(ESConstant.Color.Green)
         .titleForegroundColor(UIColor.white)
         .titleFont(UIFont(name: ESConstant.FontName.Bold, size: 16)!)
         
         let popupVC = PTPopupWebViewController()
         .popupAppearStyle(.fade(0.4))
         .popupDisappearStyle(.pop(0.4, true))
         
         _ = popupVC.popupView.style(style).URL(string: url!)
         popupVC.title = String(format: "Seed to %@ %@", campaign.firstName, campaign.lastName)
         popupVC.show() */
        
        let paymentVC = self.storyboard!.instantiateViewController(withIdentifier: "ESPaymentVC") as! ESPaymentVC
        paymentVC.campaign = campaign
        if let tabVC = self.tabBarController {
            tabVC.navigationController?.pushViewController(paymentVC, animated: true)
        } else {
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        
    }

}
