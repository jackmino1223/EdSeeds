//
//  ESJoinAsStuduentSocialCapitalVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/20/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ESJoinAsStudentSocialCapitalVC: ESBaseScrollViewController {

    @IBOutlet weak var txtGivenBack: KMPlaceholderTextView!
    @IBOutlet weak var txtBlog: UITextField!
    @IBOutlet weak var txtPortfolio: UITextField!
    @IBOutlet weak var txtBragging: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        txtGivenBack.makeBorder(width: 1, color: borderColor)
        txtBlog.makeBorder(width: 1, color: borderColor)
        txtPortfolio.makeBorder(width: 1, color: borderColor)
        txtBragging.makeBorder(width: 1, color: borderColor)
        
        btnNext.makeRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "SOCIAL CAPITAL"
    }

    @IBAction func onPressSubmit(_ sender: Any) {
        
        let registeringUser = appManager().registeringUser!
        
        registeringUser.howGiveBack = txtGivenBack.text
        registeringUser.yourBlog    = txtBlog.text
//        registeringUser.folio
        registeringUser.otherRights = txtBragging.text
        
        register()
    }
    
    func register() -> Void {
        
        let registeringUser = appManager().registeringUser!
        var params: [String: Any] = [:]
        params["first_name"] = registeringUser.firstName
        params["last_name"]  = registeringUser.lastName
        params["gender"]     = registeringUser.gender
        if registeringUser.birthOfDate != nil, registeringUser.birthOfDate!.characters.count > 0 {
            params["Birth_of_date"] = registeringUser.birthOfDate!
        }
        if registeringUser.studentId != nil, registeringUser.studentId!.characters.count > 0 {
            params["Student_id"] = registeringUser.studentId!
        }
        if registeringUser.locations.count > 0 {
            params["location"] = registeringUser.locations[0].id
        }
        if registeringUser.universities.count > 0 {
            params["university"] = registeringUser.universities[0].id
        }
        if registeringUser.majors.count > 0 {
            params["Major"] = registeringUser.majors[0].id
        }
        if registeringUser.degrees.count > 0 {
            params["degree"] = registeringUser.degrees[0].id
        }
        if registeringUser.scholarshipPrograms.count > 0 {
            params["Scholarship_prg"] = registeringUser.scholarshipPrograms[0].id
        }
        if registeringUser.scholarshipCode != nil, registeringUser.scholarshipCode!.characters.count > 0 {
            params["Scholarship_code"] = registeringUser.scholarshipCode!
        }
        if registeringUser.statement != nil, registeringUser.statement!.characters.count > 0 {
            params["Statement"] = registeringUser.statement!
        }
        if registeringUser.whyFund != nil, registeringUser.whyFund!.characters.count > 0 {
            params["Why_fund"] = registeringUser.whyFund!
        }
        if registeringUser.howGiveBack != nil, registeringUser.howGiveBack!.characters.count > 0 {
            params["Howgiveback"] = registeringUser.howGiveBack!
        }
        if registeringUser.yourBlog != nil, registeringUser.yourBlog!.characters.count > 0 {
            params["Yourblog"] = registeringUser.yourBlog!
        }
        if registeringUser.otherRights != nil, registeringUser.otherRights!.characters.count > 0 {
            params["Other_rights"] = registeringUser.otherRights!
        }
        
        showLoadingIndicator()
        
        /*
        requestManager().editProfile(user: appManager().registeringUser!, extraParams: params) { (user: ESUserModel?, errorMessage: String?) in
            if user != nil {
                
                self.appManager().currentUser = user
                self.appManager().currentUser?.token = self.appManager().registeringUser?.token
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            } else {
                self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
            }
            
            self.stopLoadingIndicator()

        } */
        
        
        requestManager().register(type: .studuent,
                                  email: registeringUser.email,
                                  password: appManager().registeringUserPassword,
                                  deviceToken: appManager().fcmRefreshToken,
                                  authType: registeringUser.authType,
                                  authId: registeringUser.authId,
                                  photo: appManager().registeringUserPhoto,
                                  extraParams: params) { (user: ESUserModel?, errorMessage: String?) in
                                    
                                    if user != nil {
                                        
                                        self.appManager().currentUser = user
                                        self.appManager().saveUser(id: user!.uId,
                                                                   token: user!.token!,
                                                                   email: user!.email,
                                                                   password: self.appManager().registeringUserPassword)

                                        self.navigationController?.dismiss(animated: true, completion: nil)
                                        
                                    } else {
                                        self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
                                    }
                                    
                                    self.stopLoadingIndicator()

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
