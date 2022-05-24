//
//  ESMainTabVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESMainTabVC: UITabBarController, UITabBarControllerDelegate {

    var isLoggedin: Bool = false
    var isLoadingUserinformation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        /*
        let donorHomeVC = self.storyboard!.instantiateViewController(withIdentifier: "ESDonorHomeVC") as! ESDonorHomeVC
//        let donorProfileSettingVC = self.storyboard!.instantiateViewController(withIdentifier: "ESDonorProfileSettingVC") as! ESDonorProfileSettingVC
        let notificationVC = self.storyboard!.instantiateViewController(withIdentifier: "ESNotificationVC") as! ESNotificationVC
        let searchVC = self.storyboard!.instantiateViewController(withIdentifier: "ESSearchVC") as! ESSearchVC
        
        let studentHomeVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentHomeVC") as! ESStudentHomeVC
        let studentProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentProfileEditVC") as! ESStudentProfileEditVC
        
        self.viewControllers = [donorHomeVC, studentHomeVC, studentProfileVC, notificationVC, searchVC]
        */
        
        self.view.backgroundColor = ESConstant.Color.ViewBackground
        
        let savedUserinformation = appManager().getUser()
//        if let userId = savedUserinformation.0, userId > 0 {
        if let email = savedUserinformation.2 {
            let password = savedUserinformation.3
            let authId   = savedUserinformation.4
            if password == nil && authId == nil {
                openLoginController()
            } else {
                isLoadingUserinformation = true
                requestManager().login(email: email, password: password, authId: authId, deviceToken: nil, complete: { (user: ESUserModel?, errorMessage: String?) in
                    
                    if user != nil {
                        self.appManager().currentUser = user
                        self.isLoggedin = true
                        self.openMainViewControllers()
                        
                        self.appManager().saveUser(id: user!.uId, token: user!.token!, email: user!.email, password: nil)
                        
                    } else {
                        self.openLoginController()
                    }
                    self.isLoadingUserinformation = false
                    
                })
            }
        }
        
        loadSuggestionDatas()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if appManager().currentUser != nil  {
            if isLoggedin == false {
                isLoggedin = true
                openMainViewControllers()
            }
        } else {
            isLoggedin = false
            if isLoadingUserinformation == false {
                openLoginController()
            }
        }
        
    }
    
    func openMainViewControllers() -> Void {
        
        let currentUser = appManager().currentUser!
        
        let notificationVC = self.storyboard!.instantiateViewController(withIdentifier: "ESNotificationVC") as! ESNotificationVC
        let searchVC = self.storyboard!.instantiateViewController(withIdentifier: "ESSearchVC") as! ESSearchVC
        
        if currentUser.type == .donor || currentUser.type == .advocate {
            let donorHomeVC = self.storyboard!.instantiateViewController(withIdentifier: "ESDonorHomeVC") as! ESDonorHomeVC
            let donorProfileSettingVC = self.storyboard!.instantiateViewController(withIdentifier: "ESDonorProfileSettingVC") as! ESDonorProfileSettingVC
            
            self.viewControllers = [donorHomeVC, donorProfileSettingVC, notificationVC, searchVC]
            
        } else {
            let studentHomeVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentHomeVC") as! ESStudentHomeVC
            let studentProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentProfileEditVC") as! ESStudentProfileEditVC
            self.viewControllers = [studentHomeVC, studentProfileVC, notificationVC, searchVC]
            
        }
        getNotifications()
    }
    
    func openLoginController() -> Void {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = loginStoryboard.instantiateInitialViewController() {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func loadSuggestionDatas() {
        requestManager().getCountries { (countryResult: [ESCountryModel]?, countryError: String?) in
            if countryResult != nil {
                self.appManager().arrayCountries = countryResult!
            }
            print("Loaded Countries")
            
            self.requestManager().getInstitutions(complete: { (instResult: [ESBaseObjectModel]?, instError: String?) in
                if instResult != nil {
                    self.appManager().arrayInstitutions = instResult!
                }
                
            print("Loaded Institutions")
                
                self.requestManager().getDegrees(complete: { (degreeResult: [ESBaseObjectModel]?, degreeError: String?) in
                    if degreeResult != nil {
                        self.appManager().arrayDegrees = degreeResult!
                    }
                    
            print("Loaded Degrees")
                    
                    self.requestManager().getMajors(complete: { (majorResult: [ESBaseObjectModel]?, majorError: String?) in
                        if majorResult != nil {
                            self.appManager().arrayMajors = majorResult!
                        }
                        
            print("Loaded Majors")
                        
                        self.requestManager().getScholarshipPrograms(complete: { (scholarshipResult: [ESBaseObjectModel]?, scholarshipError: String?) in
                            if scholarshipResult != nil {
                                self.appManager().arrayScholarshipPrograms = scholarshipResult!
                            }
                            
            print("Loaded Scholarship programs")
                            
                            self.requestManager().getSkills(complete: { (skillResult: [ESBaseObjectModel]?, skillError: String?) in
                                if skillResult != nil {
                                    self.appManager().arraySkills = skillResult!
                                }
                                
            print("Loaded Skills")
                                
                                self.requestManager().getReportTypes(complete: { (reportTypesResult: [ESBaseObjectModel]?, skillError: String?) in
                                    if reportTypesResult != nil {
                                        self.appManager().arrayReportTypes = reportTypesResult!
                                    }
                                    
            print("Loaded Report Types")
                                    
                                })

                            })
                            
                        })
                    })
                })
            })
        }
    }
    
    fileprivate func getNotifications() {
        requestManager().getNotification(user: appManager().currentUser!) { (notifications: [ESNotificationModel]?, lastId: Int?, errorMessage: String?) in
            if notifications != nil {
                var badgeCount: Int = 0
                for notific in notifications! {
                    if notific.seen == false {
                        badgeCount += 1
                    }
                }
                let badgeValue: String? = badgeCount > 0 ? String(badgeCount) : nil
                self.viewControllers![2].tabBarItem.badgeValue = badgeValue
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers!.index(of: viewController) {
            let editVC = self.viewControllers![1] as! ESProfileEditBaseVC
            if index != 1 && editVC.isEditedProfile {
                showAlert(title: "Warning", message: "You didn't save some changed profile information. Would you save profile information?", okButtonTitle: "Save", cancelButtonTitle: "Discard", okClosure: { 
                    editVC.saveProfile(complete: { (success: Bool) in
                        if success {
                            editVC.isEditedProfile = false
                        }
                    })
                })
                return false
            }
        }
        appManager().activeVideoPlayer?.pause()
        return true
    }
    
    func logout() -> Void {
        self.viewControllers = nil
        
        isLoggedin = false
        self.appManager().clearUser()
        self.appManager().currentUser = nil
        self.appManager().currentUserSkills.removeAll()

        openLoginController()
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
