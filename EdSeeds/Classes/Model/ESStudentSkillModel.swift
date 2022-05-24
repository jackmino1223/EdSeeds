//
//  ESStudentSkillModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESStudentSkillModel: ESBaseObjectModel {

    var studentSkillId: Int = 0
    var skillId: Int = 0
    var endorsments: [ESEndorsmentModel] = []
    
    override init(json: JSON) {
        super.init(json: json)
        
        skillId = json["skill_id"].intValue
        id = skillId
        studentSkillId = json["student_skill_id"].intValue
        
        for jsonElem in json["endorsments"].arrayValue {
            endorsments.append(ESEndorsmentModel(json: jsonElem))
        }
        
    }
    
}

class ESEndorsmentModel: ESObject {
    var firstName: String = ""
    var lastName: String = ""
    var uId: Int = 0
    var endorseTime: Date?
    var profilePhoto: String?
    
    init(json: JSON) {
        super.init()
        firstName = json["end_first_name"].stringValue
        lastName  = json["end_last_name"].stringValue
        uId       = json["u_id"].intValue
        endorseTime = ESConstant.ESDateFormatter.Default.date(from: json["endorse_time"].stringValue)
        profilePhoto = json["profile_photo"].string
    }
    
    init(firstName fn: String, lastName ln: String, userId id: Int, profilePhoto profileUrl: String?) {
        super.init()
        firstName = fn
        lastName = ln
        uId = id
        endorseTime = Date()
        profilePhoto = profileUrl
    }
}
