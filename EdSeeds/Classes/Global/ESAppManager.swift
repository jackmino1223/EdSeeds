//
//  ESAppManager.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESAppManager: NSObject {

    static let sharedManager : ESAppManager = {
        let instance = ESAppManager()
        return instance
    }()

    let UserDefaultKeyUserId = "userId"
    let UserDefaultKeyUserToken = "userToken"
    let UserDefaultKeyUserEmail = "userEmail"
    let UserDefaultKeyUserPassword = "userPassword"
    let UserDefaultKeyUserAuthId = "authId"
    
    func saveUser(id: Int, token: String, email: String, password: String?, authId: String? = nil) -> Void {
        let userDefault = UserDefaults.standard
        userDefault.set(id, forKey: UserDefaultKeyUserId)
        userDefault.set(token, forKey: UserDefaultKeyUserToken)
        userDefault.set(email, forKey: UserDefaultKeyUserEmail)
        if password != nil {
            userDefault.set(password, forKey: UserDefaultKeyUserPassword)
        } else {
            userDefault.removeObject(forKey: UserDefaultKeyUserPassword)
        }
        if authId != nil {
            userDefault.set(authId!, forKey: UserDefaultKeyUserAuthId)
        } else {
            userDefault.removeObject(forKey: UserDefaultKeyUserAuthId)
        }
        userDefault.synchronize()
    }
    
    func getUser() -> (Int?, String?, String?, String?, String?) {
        let userDefault = UserDefaults.standard
        let userId = userDefault.integer(forKey: UserDefaultKeyUserId)
        let token  = userDefault.string(forKey: UserDefaultKeyUserToken)
        let email  = userDefault.string(forKey: UserDefaultKeyUserEmail)
        let password = userDefault.string(forKey: UserDefaultKeyUserPassword)
        let authId = userDefault.string(forKey: UserDefaultKeyUserAuthId)
        return (userId, token, email, password, authId)
    }
    
    func clearUser() -> Void {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: UserDefaultKeyUserId)
        userDefault.removeObject(forKey: UserDefaultKeyUserToken)
        userDefault.removeObject(forKey: UserDefaultKeyUserEmail)
        userDefault.removeObject(forKey: UserDefaultKeyUserPassword)
        userDefault.removeObject(forKey: UserDefaultKeyUserAuthId)
        userDefault.synchronize()
    }
    
    var registeringUser: ESUserModel?
    var registeringUserPassword: String?
    var registeringUserPhoto: UIImage?
    
    var currentUser: ESUserModel?
    var currentUserSkills: [ESStudentSkillModel] = []
    
    var arrayCountries: [ESCountryModel]?
    var arrayInstitutions: [ESBaseObjectModel]?
    var arrayDegrees: [ESBaseObjectModel]?
    var arrayMajors: [ESBaseObjectModel]?
    var arrayScholarshipPrograms: [ESBaseObjectModel]?
    var arraySkills: [ESBaseObjectModel]?
    var arrayReportTypes: [ESBaseObjectModel]?
    
    private var _activeVideoPlayer: BMPlayer?
    var activeVideoPlayer: BMPlayer? {
        set {
            if _activeVideoPlayer != newValue {
                _activeVideoPlayer?.pause()
                _activeVideoPlayer = newValue
            }
        }
        get {
            return _activeVideoPlayer
        }
    }
    
    var fcmRefreshToken: String? {
        didSet {
            updateFCMRefreshToken()
        }
    }
    
    static func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    func updateFCMRefreshToken() -> Void {
        if fcmRefreshToken != nil && currentUser != nil {
            let params: [String: Any] = [
                "u_app_id": fcmRefreshToken!
            ]
            ESRequestManager.sharedManager.editProfile(user: currentUser!, extraParams: params, complete: { (user: ESUserModel?, errorMessage: String?) in
                print("Updated FCM Token : %@", self.fcmRefreshToken!)
            })
            currentUser!.appId = fcmRefreshToken
        }
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
