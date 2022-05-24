//
//  ESJoinAsStudentVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import DatePickerDialog

class ESJoinAsStudentVC: ESSocialConnectingBaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var viewStudentID: UIView!
    @IBOutlet weak var txtStudentID: UITextField!
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var viewDateOfBirth: UIView!
    @IBOutlet weak var txtBirthDay: UITextField!
    @IBOutlet weak var txtBirthMonth: UITextField!
    @IBOutlet weak var txtBirthYear: UITextField!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    fileprivate var isMale: Bool? = nil
    fileprivate var dateBirthday: Date?
    fileprivate var socialAuthType: AuthType = .Default
    fileprivate var socialAuthID: String?
    
//    @IBOutlet weak var lblTermsAndConditions: UILabel!

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = ESConstant.Color.BorderColor
        viewFirstName.makeBorder(width: 1, color: borderColor)
        viewLastName.makeBorder(width: 1, color: borderColor)
        viewStudentID.makeBorder(width: 1, color: borderColor)
        viewDateOfBirth.makeBorder(width: 1, color: borderColor)
        viewEmail.makeBorder(width: 1, color: borderColor)
        viewPassword.makeBorder(width: 1, color: borderColor)
        
        btnNext.makeRound()
        
        let tapBirthDay = UITapGestureRecognizer(target: self, action: #selector(onPressBirthday(_:)))
        viewDateOfBirth.addGestureRecognizer(tapBirthDay)
        
        btnMale.setBackgroundImage(UIImage(named: "iconMaleUnselected"), for: .normal)
        btnFemale.setBackgroundImage(UIImage(named: "iconFemaleUnselected"), for: .normal)

//        let tapTermsConditions = UITapGestureRecognizer(target: self, action: #selector(onPressTermsAndConditions(_:)))
//        lblTermsAndConditions.addGestureRecognizer(tapTermsConditions)
//        lblTermsAndConditions.isUserInteractionEnabled = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "JOIN AS STUDENT"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let borderColor = ESConstant.Color.BorderColor
        if textField == txtFirstName {
            viewFirstName.makeBorder(width: 1, color: borderColor)
        } else if textField == txtLastName {
            viewLastName.makeBorder(width: 1, color: borderColor)
        } else if textField == txtEmail {
            viewEmail.makeBorder(width: 1, color: borderColor)
        } else if textField == txtPassword {
            viewPassword.makeBorder(width: 1, color: borderColor)
        }
    }
    
    fileprivate func availableRegisterationUserInfo() -> Bool {
        var isAvailable = true
        let redBorderColor = UIColor.red
        if txtFirstName.text!.characters.count == 0 {
            viewFirstName.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        if txtLastName.text!.characters.count == 0 {
            viewLastName.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        if ESAppManager.isValidEmail(txtEmail.text!) == false {
            viewEmail.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        if txtPassword.text!.characters.count < 6 && self.socialAuthID == nil {
            viewPassword.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        
        return isAvailable
    }
    
    @IBAction func onPressGender(_ sender: Any) {
        if (sender as? UIButton) == btnMale {
            btnMale.setBackgroundImage(UIImage(named: "iconMaleSelected"), for: .normal)
            btnFemale.setBackgroundImage(UIImage(named: "iconFemaleUnselected"), for: .normal)
            isMale = true
        } else {
            btnMale.setBackgroundImage(UIImage(named: "iconMaleUnselected"), for: .normal)
            btnFemale.setBackgroundImage(UIImage(named: "iconFemaleSelected"), for: .normal)
            isMale = false
        }
    }
    
    func onPressBirthday(_ sender: Any) -> Void {
        DatePickerDialog().show(title: NSLocalizedString("Select Date", comment: ""),
                                doneButtonTitle: NSLocalizedString("Select", comment: ""),
                                cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                datePickerMode: .date) { (date) -> Void in
                                    if date != nil {
                                        if date! > Date() {
                                            self.showSimpleAlert(title: "Warning", message: "Date of Birth cannot be in the future.", dismissed: nil)
                                        } else {
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "MM"
                                            self.txtBirthMonth.text = dateFormatter.string(from: date!)
                                            dateFormatter.dateFormat = "dd"
                                            self.txtBirthDay.text = dateFormatter.string(from: date!)
                                            dateFormatter.dateFormat = "yyyy"
                                            self.txtBirthYear.text = dateFormatter.string(from: date!)
                                            self.dateBirthday = date
                                        }
                                    }
        }

    }
    
    @IBAction func onPressNext(_ sender: Any) {
        if availableRegisterationUserInfo() {
            
            var birthdayString: String? 
            if dateBirthday != nil {
                birthdayString = ESConstant.ESDateFormatter.OnlyDate.string(from: dateBirthday!)
            }
            
            var genderString: String?
            if isMale != nil {
                genderString = isMale! ? "M" : "F"
            }
            
            registerAndNextWith(authType: self.socialAuthType,
                                email: self.txtEmail.text,
                                password: self.txtPassword.text,
                                firstName: self.txtFirstName.text!,
                                lastName: self.txtLastName.text!,
                                authId: self.socialAuthID,
                                studentId: self.txtStudentID.text,
                                birthday: birthdayString,
                                gender: genderString)
        } else {
            
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
                self.txtEmail.text = email
                self.txtFirstName.text = firstName
                self.txtLastName.text = lastName
                self.txtPassword.text = nil
            }
        } else {
            self.txtEmail.text = email
            self.txtFirstName.text = firstName
            self.txtLastName.text = lastName
            self.txtPassword.text = nil
        }
        self.socialAuthID = authId
        self.socialAuthType = authType
        
        /*
        registerAndNextWith(authType: authType,
                            email: email,
                            password: nil,
                            firstName: firstName ?? "",
                            lastName: lastName ?? "",
                            authId: authId,
                            studentId: nil,
                            birthday: birthday,
                            gender: gender) */

    }
    
    fileprivate func registerAndNextWith(authType: AuthType,
                                         email: String?,
                                         password: String?,
                                         firstName: String,
                                         lastName: String,
                                         authId: String?,
                                         studentId: String? = nil,
                                         birthday: String? = nil,
                                         gender: String? = nil)
    {
        let registeringUser = ESUserModel()
        registeringUser.authType = authType
        registeringUser.email = email ?? ""
        registeringUser.firstName = firstName
        registeringUser.lastName = lastName
        registeringUser.studentId = studentId
        registeringUser.authId = authId
        
        registeringUser.birthOfDate = birthday
        registeringUser.gender = birthday ?? ""
        
        appManager().registeringUser = registeringUser
        appManager().registeringUserPassword = password
        
        var params: [String : Any] = [
            "first_name": firstName,
            "last_name" : lastName,
        ]
        if studentId != nil {
            params["student_id"] = studentId!
        }
        if gender != nil {
            params["gender"] = gender!
        }
        if birthday != nil {
            params["birth_of_date"] = birthday!
        }
        
        self.showLoadingIndicator()
        
        requestManager().checkUserExist(email: email!) { (errorMessage: String?) in
            if errorMessage != nil {
                self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: { 
                    self.resetUserInfo()
                })
            } else {
                self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsStudentCompleteVC, sender: self)
            }
            self.stopLoadingIndicator()
        }
        
        /*
        requestManager().register(type: .studuent, email: email, password: password, deviceToken: appManager().fcmRefreshToken, authType: authType, authId: authId, photo: nil, extraParams: params) { (user: ESUserModel?, errorMessage: String?) in
            if user != nil {
                self.appManager().registeringUser = user!
                
                self.appManager().saveUser(id: user!.uId,
                                           token: user!.token!,
                                           email: user!.email,
                                           password: self.appManager().registeringUserPassword)

                
                self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsStudentCompleteVC, sender: self)
            } else {
                self.showSimpleAlert(title: "Error", message: errorMessage!, dismissed: nil)
            }
            self.stopAnimating()
        } */
        
    }
    
    private func resetUserInfo() {
//        self.appManager().registeringUser = nil
//        self.appManager().registeringUserPassword = nil
        self.socialAuthID = nil
        self.socialAuthType = .Default
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
