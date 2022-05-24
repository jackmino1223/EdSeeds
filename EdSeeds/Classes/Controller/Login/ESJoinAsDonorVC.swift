//
//  ESJoinAsDonorVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESJoinAsDonorVC: ESSocialConnectingBaseVC {

    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnNext: UIButton!
//    @IBOutlet weak var lblTermsAndConditions: UILabel!
    
    var isDonorAccount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        viewFirstName.makeBorder(width: 1, color: borderColor)
        viewLastName.makeBorder(width: 1, color: borderColor)
        viewEmail.makeBorder(width: 1, color: borderColor)
        viewPassword.makeBorder(width: 1, color: borderColor)
        
        btnNext.makeRound()
        
//        let tapTermsConditions = UITapGestureRecognizer(target: self, action: #selector(onPressTermsAndConditions(_:)))
//        lblTermsAndConditions.addGestureRecognizer(tapTermsConditions)
//        lblTermsAndConditions.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        if isDonorAccount {
            return "JOIN AS DONOR"
        } else {
            return "JOIN AS ADVOCATE"
        }
        
    }

    fileprivate func availableRegisterationInfo() -> Bool {
        var available = true
        if txtFirstName.text!.characters.count == 0 {
            available = false
        } else if txtLastName.text!.characters.count == 0 {
            available = false
        } else if txtEmail.text!.characters.count == 0 {
            available = false
        } else if txtPassword.text!.characters.count == 0 {
            available = false
        }
        return available
    }
    
    @IBAction func onPressNext(_ sender: Any) {
        if availableRegisterationInfo() {
            let firstName = txtFirstName.text!
            let lastName  = txtLastName.text!
            let email     = txtEmail.text!
            let password  = txtPassword.text!
            
            register(authType: .Default, email: email, password: password, firstName: firstName, lastName: lastName, authId: nil)
            
        } else {
            showSimpleAlert(title: "Warning", message: "Please input all information.", dismissed: nil)
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
        
        if shouldMainThread {
            DispatchQueue.main.async {
                self.txtFirstName.text = firstName
                self.txtLastName.text = lastName
                self.txtEmail.text = email
            }
        } else {
            self.txtFirstName.text = firstName
            self.txtLastName.text = lastName
            self.txtEmail.text = email
        }

        if email == nil {
            self.showSimpleAlert(title: "Error",
                                 message: "Can't get your email address from social account. Please contact to app developement team.",
                                 dismissed: nil)
        } else {
            register(authType: authType, email: email!, password: nil, firstName: (firstName ?? ""), lastName: (lastName ?? ""), authId: authId)
        }
    }
    
    fileprivate func register(authType: AuthType, email: String, password: String?, firstName: String, lastName: String, authId: String?) {
        let params: [String: Any] = [
            "first_name": firstName,
            "last_name" : lastName,
            ]
        
        showLoadingIndicator()
        
        requestManager().register(type: (isDonorAccount ? .donor : .advocate),
                                  email: email,
                                  password: password,
                                  deviceToken: appManager().fcmRefreshToken,
                                  authType: authType,
                                  authId: authId,
                                  photo: nil,
                                  extraParams: params,
                                  complete: { (user: ESUserModel?, errorMessage: String?) in
                                    
                                    if user != nil {
                                        
                                        self.appManager().currentUser = user
                                        self.appManager().saveUser(id: user!.uId, token: user!.token!, email: user!.email, password: password)
                                        
                                        self.navigationController?.dismiss(animated: true, completion: nil)
                                        
                                    } else {
                                        self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
                                    }
                                    self.stopLoadingIndicator()
        })

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
