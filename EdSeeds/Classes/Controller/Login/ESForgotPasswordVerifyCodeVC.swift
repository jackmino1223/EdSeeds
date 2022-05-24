//
//  ESForgotPasswordVerifyCodeVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/15/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESForgotPasswordVerifyCodeVC: ESForgotPasswordBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Verify Code"
    }

    override func availableInfo() -> Bool {
        if let code = self.textfield0.text, code.characters.count > 0 {
            
            return true
            
        }
        self.lblWarning.text = "Invalid Verify Code"
        self.lblWarning.isHidden = false
        
        self.textfield0.makeBorder(width: 1, color: UIColor.red)
        return false
    }
    
    override func submit() {
        self.submitting(true)
        
        requestManager().forgetPassword(email: registeredEmail, verifyCode: textfield0.text!) { (errorMessage: String?) in
            if errorMessage == nil {
                
                self.performSegue(withIdentifier: ESConstant.Segue.gotoForgotPasswordNewPasswordVC, sender: self)
                
            } else {
                self.lblWarning.text = errorMessage
                self.lblWarning.isHidden = false
            }
            self.submitting(false)
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == ESConstant.Segue.gotoForgotPasswordNewPasswordVC {
                let vc = segue.destination as! ESForgotPasswordBaseVC
                vc.registeredEmail = registeredEmail
            }
        }
    }

}
