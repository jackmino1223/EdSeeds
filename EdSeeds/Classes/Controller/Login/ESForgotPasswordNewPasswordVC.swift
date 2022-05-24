//
//  ESForgotPasswordNewPasswordVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/15/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESForgotPasswordNewPasswordVC: ESForgotPasswordBaseVC {

    @IBOutlet weak var textfield1: ESTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        textfield1.makeBorder(width: 1, color: borderColor)
        textfield1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        var vcs = self.navigationController!.viewControllers
        vcs.remove(at: vcs.count - 3)
        vcs.remove(at: vcs.count - 2)
        self.navigationController!.viewControllers = vcs
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Verify Code"
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        
        if textField == textfield1 {
            self.textfield1.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        }

    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfield0 {
            textfield1.becomeFirstResponder()
        } else if textField == textfield1 {
            textfield1.resignFirstResponder()
            onPressNext(btnNext)
        }
        return false
    }
    
    override func availableInfo() -> Bool {
        
        self.lblWarning.text = "Invalid Password"
        if let newpassword = self.textfield0.text, newpassword.characters.count >= 6 {
            if textfield0.text == textfield1.text {
                return true
            }
        } else {
            self.lblWarning.text = "Password should be at least 6 characters."
        }
        
        self.lblWarning.isHidden = false
        
        self.textfield0.makeBorder(width: 1, color: UIColor.red)
        self.textfield1.makeBorder(width: 1, color: UIColor.red)
        return false
    }
    
    override func submit() {
        self.submitting(true)
        
        requestManager().forgetPassword(email: registeredEmail, newPassword: textfield0.text!) { (errorMessage: String?) in
            if errorMessage == nil {
                
                self.showSimpleAlert(title: "Success", message: "Your password has been change to new password.", dismissed: { 
                    let _ = self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                self.lblWarning.text = errorMessage
                self.lblWarning.isHidden = false
            }
            self.submitting(false)
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
