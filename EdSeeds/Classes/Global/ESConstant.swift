//
//  ESConstant.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftHEXColors

struct AppKey {
    static let LinkedinClientId = "78bmuihoe9sqhs"
    static let LinkedinClientSecret = "efiTbRdYJeJzpsPN"
    static let LinkedinRedirectURL = "http://35.163.249.175/ws/linkedin/oauth"
}

struct PaymentAppKey {
    static let Stripe = "pk_live_I8bQ14hI1VwVO1gJG0n4Tm6V"
    static let PaypalProduction = "AVubIRqs2ZtFQdcymtSmkNvQpKgfkxS9kOEzjd0_xaBrWxysxLPhD0m1_OLnjBwYVzx2WbinNXv8oQY2"
    static let PaypalSandbox    = "ATow1CDfdj_aSlaqITyJ8UC79NvWSScdcuEari6RYGVKHJXl8h2tHwUW-JMQJA5bUjPcL1Kq9W3_spyy"
}

struct ESConstant {
    
    struct FontName {
        static let Regular      : String    = "Quicksand-Regular"
        static let Bold         : String    = "Quicksand-Bold"
        static let BoldItalic   : String    = "Quicksand-BoldItalic"
        static let Light        : String    = "Quicksand-Light"
        static let LightItalic  : String    = "Quicksand-LightItalic"
        static let Italic       : String    = "Quicksand-Italic"
    }
    
    struct Color {
        static let Pink             = UIColor(hexString: "#FF00E4")!
        static let Green            = UIColor(hexString: "#00E819")!
        static let DarkGreen        = UIColor(hexString: "#00AB10")!
        static let DarkFontColor    = UIColor(hexString: "#525252")!
        static let ViewBackground   = UIColor(hexString: "#F5F5F5")!
        static let BorderColor      = UIColor(hexString: "#D8D8D8")!
        static let GrayFontColor    = UIColor(hexString: "#AAAAAA")!
    }
    
    struct Segue {
        static let gotoJoinAsDonorVC            = "gotoJoinAsDonorVC"
        static let gotoJoinAsStudentVC          = "gotoJoinAsStudentVC"
        static let gotoJoinAsStudentCompleteVC  = "gotoJoinAsStudentCompleteVC"
        static let gotoJoinAsStudentAvatarVC    = "gotoJoinAsStudentAvatarVC"
        static let gotoJoinAsStudentSocialCapitalVC = "gotoJoinAsStudentSocialCapitalVC"
        static let gotoStudentAddSkillVC        = "gotoStudentAddSkillVC"
        static let gotoLoginVC                  = "gotoLoginVC"
        static let gotoStudentNewCampainVC      = "gotoStudentNewCampainVC"
        static let gotoStudentAddNewVideoVC     = "gotoStudentAddNewVideoVC"
        static let gotoForgotPasswordVerifyCodeVC = "gotoForgotPasswordVerifyCodeVC"
        static let gotoForgotPasswordNewPasswordVC = "gotoForgotPasswordNewPasswordVC"
        static let gotoForgotPasswordVC         = "gotoForgotPasswordVC"
    }
    
    struct ESDateFormatter {
        static let Default: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            return dateFormatter
        }()
        static let OnlyDate: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
        static let OnlyTime: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter
        }()
        static let FacebookBirthday: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter
        }()
    }
    
    struct ImageFileName {
        static let userAvatarLight = "iconPlaceholderAvatarLight"
        
    }
    
    struct Notification {
//        static let CreatedNewCampaign   = "com.edseed.notification.createdNewCampaign"
        static let AddedNewVideo        = "com.edseed.notification.addedNewVideo"
        static let UpdatedStudentSkill  = "com.edseed.notification.updatedStudentSkill"
        static let DownloadedThumbnail  = "com.edseed.notification.downloadedThumbnail"
//        static let UpdatedProfileInfo   = "com.edseed.notification.updatedProfile"
        static let ReloadCampaigns      = "com.edseed.notification.reloadCampaigns"
    }
}

enum UserType: String {
    case studuent = "Student"
    case donor = "Donor"
    case advocate = "Advocate"
}

enum UserTypeNumber: Int {
    case undefinded = 0
    case studuent = 1
    case donor = 2
    case advocate = 3
}

enum AuthType: Int {
    case Default = 0
    case Facebook = 1
    case LinkedIn = 2
    case GooglePlus = 3
}

let fieldTitle: String = "title"
let fieldType: String  = "type"
let fieldText: String  = "text"
let parameterName: String = "parameterName"
let fieldPlaceholder: String = "placeholder"
