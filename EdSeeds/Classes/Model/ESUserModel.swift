//
//  ESUserModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESUserModel: ESObject {

    var uId: Int = 0
    var email: String!
    var type: UserTypeNumber = .undefinded
    var status: Int = 0
    var appId: String?
    var locations: [ESBaseObjectModel] = []
    var authType: AuthType = .Default
    var authId: String?
    var profilePhoto: String?
    var universities: [ESBaseObjectModel] = []
    var createDate: Date?
    var lastLogin: Date?
    var fullName: String!
    var firstName: String!
    var lastName: String!
    var gender: String!
    var platform: String!
    var majors: [ESBaseObjectModel] = []
    var degrees: [ESBaseObjectModel] = []
    var scholarshipPrograms: [ESBaseObjectModel] = []
    var profileCompleted: Int = 0
    
    var userDetails: String?
    var statement: String?
    var whyFund: String?
    var scholarshipCode: String?
    var studentId: String?
    var birthOfDate: String?
    var howGiveBack: String?
    var yourBlog: String?
    var otherRights: String?
    var socialCaptial: String?
    var portfolio: String?
    var token: String?
    
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        uId = json["u_id"].intValue
        email = json["email"].stringValue
        type = UserTypeNumber(rawValue: json["type"].intValue)!
        status = json["status"].intValue
        appId = json["app_id"].string
        
        for item in json["locations"].arrayValue {
            let location = ESBaseObjectModel(json: item, idFieldName: "location_id")
            locations.append(location)
        }
        
        authType = AuthType(rawValue: json["auth_type"].intValue)!
        authId = json["auth_id"].string
        profilePhoto = json["profile_photo"].string
        
        for item in json["universities"].arrayValue {
            let university = ESBaseObjectModel(json: item, idFieldName: "inst_id")
            universities.append(university)
        }
        
        createDate = ESConstant.ESDateFormatter.Default.date(from: json["create_date"].stringValue)
        lastLogin  = ESConstant.ESDateFormatter.Default.date(from: json["last_login"].stringValue)
        fullName = json["full_name"].stringValue
        firstName = json["first_name"].stringValue
        lastName  = json["last_name"].stringValue
        gender    = json["gender"].stringValue
        platform  = json["platform"].stringValue
        
        for item in json["majors"].arrayValue {
            let major = ESBaseObjectModel(json: item)
            majors.append(major)
        }

        for item in json["degrees"].arrayValue {
            let degree = ESBaseObjectModel(json: item)
            degrees.append(degree)
        }

        for item in json["scholarship_prg"].arrayValue {
            let scholarshipProgram = ESBaseObjectModel(json: item)
            scholarshipPrograms.append(scholarshipProgram)
        }

        profileCompleted = json["profile_completed"].intValue
        
        userDetails     = json["user_details"].string
        statement       = json["statement"].string
        whyFund         = json["why_fund"].string
        scholarshipCode = json["scholarship_code"].string
        studentId       = json["student_id"].string
        birthOfDate     = json["birthofdate"].string
        howGiveBack     = json["how_give_back"].string
        yourBlog        = json["your_blog"].string
        otherRights     = json["other_rights"].string
        socialCaptial   = json["social_captial"].string
        portfolio       = json["portfolio"].string
    }
    
}
