//
//  ESSocialConnectingBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/1/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import LinkedinSwift
import SwiftyJSON
import MBProgressHUD

class ESSocialConnectingBaseVC: ESBaseScrollViewController, GIDSignInUIDelegate, GIDSignInDelegate, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLinkedIn: UIButton!
    @IBOutlet weak var btnGooglePlus: UIButton!
//    @IBOutlet weak var viewGoogleSignButton: GIDSignInButton!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    
    var docController: UIDocumentInteractionController?
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Social login button action
    
    @IBAction func onPressFacebook(_ sender: Any) {
        self.startLoggingIn()
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (loginResult: FBSDKLoginManagerLoginResult?, loginError: Error?) in
            if loginResult != nil {
                
                if loginResult!.isCancelled {
                    self.endLogin()
                } else {
                    
                    let params: [String: Any] = [
                        "fields" : "id,name,first_name,last_name,email,gender,birthday"
                    ]
                    FBSDKGraphRequest(graphPath: "me", parameters: params).start(completionHandler: { (requestConnection: FBSDKGraphRequestConnection?, result: Any?, requestError: Error?) in
                        if let userInfo = result as? [AnyHashable: Any] {
                            if let fbId = userInfo["id"] as? String {
                                let firstName = userInfo["first_name"] as? String
                                let lastName  = userInfo["last_name"] as? String
                                let email     = userInfo["email"] as? String
                                var gender    = userInfo["gender"] as? String
                                if gender != nil {
                                    if gender!.lowercased() == "male" {
                                        gender = "M"
                                    } else if gender!.lowercased() == "female" {
                                        gender = "F"
                                    } else {
                                        gender = nil
                                    }
                                }
                                var birthday  = userInfo["birthday"] as? String
                                if birthday != nil {
                                    if let date = ESConstant.ESDateFormatter.FacebookBirthday.date(from: birthday!) {
                                        birthday = ESConstant.ESDateFormatter.OnlyDate.string(from: date)
                                    }
                                }
                                self.loggedIn(authType: .Facebook,
                                              authId: fbId,
                                              email: email,
                                              firstName: firstName,
                                              lastName: lastName,
                                              gender: gender,
                                              birthday: birthday)
//                                self.endLogin()
                            } else {
                                self.showSimpleAlert(title: "Facebook login failed", message: "Wrong User information", dismissed: nil)
                            }
                        } else if requestError != nil {
                            self.showSimpleAlert(title: "Facebook login failed", message: requestError!.localizedDescription, dismissed: nil)
                        } else {
                            self.showSimpleAlert(title: "Facebook login failed", message: "Unknow error", dismissed: nil)
                        }
                        self.endLogin()
                    })
                }
                
            }
            else if loginError != nil {
                self.showSimpleAlert(title: "Facebook login failed", message: loginError!.localizedDescription, dismissed: {
                    self.endLogin()
                })
            }
            else {
                self.showSimpleAlert(title: "Facebook login failed", message: "Unknow error", dismissed: { 
                    self.endLogin()
                })
            }
        }
    }
    
    @IBAction func onPressLinkedIn(_ sender: Any) {
        
        self.startLoggingIn()
        
        let state = "linkedin" + String(Int(Date().timeIntervalSince1970))
        let linkedinConfigration = LinkedinSwiftConfiguration(clientId: AppKey.LinkedinClientId,
                                                              clientSecret: AppKey.LinkedinClientSecret,
                                                              state: state,
                                                              permissions: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION],
                                                              redirectUrl: AppKey.LinkedinRedirectURL)
        let linkedinHelper = LinkedinSwiftHelper(configuration: linkedinConfigration!,
                                                 nativeAppChecker: nil,
                                                 clients: nil,
                                                 webOAuthPresent: self,
                                                 persistedLSToken: nil)
//        let linkedinHelper = LinkedinSwiftHelper(configuration: linkedinConfigration!)
        
        linkedinHelper.authorizeSuccess({ (token: LSLinkedinToken) in
            
            let scopes: String = [
                "id",
                "first-name",
                "last-name",
                "formatted-name",
                "picture-url",
                "email-address",
                ].map({ (elem: String) -> String in
                    return elem
                }).joined(separator: ",")
            
            let url = String(format: "https://api.linkedin.com/v1/people/~:(%@)?format=json", scopes)
            
            linkedinHelper.requestURL(url, requestType: LinkedinSwiftRequestGet, success: { (response: LSResponse) in
                let jsonObject = JSON(response.jsonObject)
                let linkedId        = jsonObject["id"].stringValue
                let email           = jsonObject["emailAddress"].stringValue
                let firstName       = jsonObject["firstName"].string
                let lastName        = jsonObject["lastName"].string
//                let formattedName   = jsonObject["firmattedName"].string
//                let pictureURL      = jsonObject["pictureUrl"].string
                
                self.endLogin(shouldMainThread: true)
                
                self.loggedIn(authType: .LinkedIn, authId: linkedId, email: email, firstName: firstName, lastName: lastName, gender: nil, birthday: nil, shouldMainThread: true)
                
            }, error: { (error: Error) in
                self.showSimpleAlert(title: "Linkedin login failed", message: error.localizedDescription, dismissed: {
                    self.endLogin(shouldMainThread: true)
                })
            })
            
        }, error: { (error: Error) in
            self.showSimpleAlert(title: "Linkedin login failed", message: error.localizedDescription, dismissed: {
                self.endLogin(shouldMainThread: true)
            })
        }) {
            self.endLogin(shouldMainThread: true)
        }
        
        /*
        if LISDKSessionManager.hasValidSession() {
            getLinkedinProfile()
        } else {
            LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION],
                                              state: nil,
                                              showGoToAppStoreDialog: false,
                                              successBlock: { (state: String?) in
                                                
                                                self.getLinkedinProfile()
                                                
            }) { (error: Error?) in
                var errorMessage: String = "Connection error"
                if error != nil {
                    errorMessage = error!.localizedDescription
                }
                self.showSimpleAlert(title: "Linkedin login failed", message: errorMessage, dismissed: { 
                    self.endLogin()
                })
            }
        } */
        
    }
    
    @IBAction func onPressGooglePlus(_ sender: Any) {
        self.startLoggingIn()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onPressTerms(_ sender: Any) {
        openDocumentInteractionView(filename: "termsfeed-terms-conditions-pdf-english", title: "Terms and Conditions")
    }
    
    @IBAction func onPressPrivacy(_ sender: Any) {
        openDocumentInteractionView(filename: "termsfeed-privacy-policy-pdf-english", title: "Privacy Policy")
    }
    
    fileprivate func startLoggingIn() {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.view.isUserInteractionEnabled = false
    }
    
    fileprivate func endLogin(shouldMainThread: Bool = false) {
//        self.stopLoadingIndicator()
        if shouldMainThread {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
                self.view.isUserInteractionEnabled = true
            }
        } else {
            MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            self.view.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func getLinkedinProfile(linkedinHelper: LinkedinSwiftHelper) {
        
        /*
        self.startLoggingIn()
        
        let url = "https://api.linkedin.com/v1/people/~?format=json"
        
        LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response: LISDKAPIResponse?) in
            print(response!.data)
            self.endLogin()
        }) { (error: LISDKAPIError?) in
            print("error" + (error?.errorResponse().data)!)
            self.endLogin()
        } */
    }
    
    internal func openDocumentInteractionView(filename: String, title: String?) {
        if let fileURL = Bundle.main.url(forResource: filename, withExtension: "pdf") {
            self.docController = UIDocumentInteractionController(url: fileURL)
            self.docController?.name = title
            self.docController?.delegate = self
            self.docController?.presentPreview(animated: true)
        }
    }
    
    func onPressTermsAndConditions(_ sender: Any) -> Void {
        
    }
    
    // MARK: - Google Sign delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            self.endLogin()
            
            loggedIn(authType: .GooglePlus, authId: userId!, email: email, firstName: familyName, lastName: givenName, gender: nil, birthday: nil)
            
        } else {
            print("\(error.localizedDescription)")
            self.showSimpleAlert(title: "Google login failed", message: error.localizedDescription, dismissed: {
                self.endLogin()
            })
        }
        
    }

    func sign(inWillDispatch signIn: GIDSignIn?, error: Error?) {
        if error != nil {
            self.showSimpleAlert(title: "Google login failed", message: error!.localizedDescription, dismissed: {
                self.endLogin()
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    // MARK: - Social sign complete
    
    internal func loggedIn(authType: AuthType, authId: String, email: String?, firstName: String?, lastName: String?, gender: String?, birthday: String?, shouldMainThread: Bool = false) {
        print(String(format: "AuthType -> %d || AuthId -> %@ || Email -> %@ || firstName -> %@ || lastName -> %@ || gender -> %@ || birthday -> %@",
            authType.rawValue, authId, email ?? "no email", firstName ?? "no", lastName ?? "no", gender ?? "no", birthday ?? "no" ))
        
        
        
    }
    
    // MARK: - UIDocumentInteractionController delegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }

}
