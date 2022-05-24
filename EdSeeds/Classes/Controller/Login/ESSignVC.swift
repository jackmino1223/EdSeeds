//
//  ESSignVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESSignVC: ESSocialConnectingBaseVC, UITextFieldDelegate {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        viewEmail.makeBorder(width: 1, color: borderColor)
        viewPassword.makeBorder(width: 1, color: borderColor)
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        btnNext.makeRound()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "SIGN IN"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            self.txtPassword.resignFirstResponder()
            onPressSign(self.btnNext)
        }
        return false
    }
    
    @IBAction func onPressSign(_ sender: Any) {
        if availableLogin() {
            login(email: txtEmail.text!, password: txtPassword.text!, authId: nil)
        }
    }
    
    private func availableLogin() -> Bool {
        if txtEmail.text!.characters.count == 0 {
            showSimpleAlert(title: "Warning",
                            message: "Please input email.",
                            dismissed: nil)
            return false
        } else if txtPassword.text!.characters.count == 0 {
            showSimpleAlert(title: "Warning",
                            message: "Please input password.",
                            dismissed: nil)
            return false
        } else {
            return true
        }
    }
    
    fileprivate func login(email: String, password: String?, authId: String?) {
        showLoadingIndicator()
        requestManager().login(email: email, password: password, authId: authId, deviceToken: appManager().fcmRefreshToken) { (user: ESUserModel?, errorMessage: String?) in
            if user != nil {
                
                self.appManager().currentUser = user!
                self.appManager().saveUser(id: user!.uId, token: user!.token!, email: user!.email, password: self.txtPassword.text!, authId: authId)
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            } else {
                self.showSimpleAlert(title: "Error",
                                     message: errorMessage,
                                     dismissed: nil)
            }
            self.stopLoadingIndicator()
        }

    }

    override func loggedIn(authType: AuthType,
                           authId: String,
                           email: String?,
                           firstName: String?,
                           lastName: String?,
                           gender: String?,
                           birthday: String?,
                           shouldMainThread: Bool = false) {
        super.loggedIn(authType: authType, authId: authId, email: email, firstName: firstName, lastName: lastName, gender: gender, birthday: birthday)
        if email == nil {
            self.showSimpleAlert(title: "Error",
                                 message: "Can't get your email address from social account. Please contact to app developement team.",
                                 dismissed: nil)
        } else {
            login(email: email!, password: nil, authId: authId)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == ESConstant.Segue.gotoForgotPasswordVC {
                txtPassword.text = nil
            }
        }
    }
    

}
