//
//  ESNotificationModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/10/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESNotificationModel: ESObject {
    
    var notId: Int = 0
    var uId: Int = 0
    var notType: Int = 0
    var targetId: Int = 0
    var title: String = ""
    var detailedTitle: String = ""
    var msgDescription: String?
    var actorFirstName: String?
    var actorLastName: String?
    var actorPhoto: String?
    var actorId: Int = 0
    var path: String?
    var seen: Bool = false
    var added: Date?
    var addedString: String?
    
    init(json: JSON) {
        notId           = json["not_id"].intValue
        uId             = json["u_id"].intValue
        notType         = json["not_type"].intValue
        targetId        = json["target_id"].intValue
        title           = json["title"].stringValue
        detailedTitle   = json["detailed_title"].stringValue
        msgDescription  = json["msg_desc"].string
        actorFirstName  = json["actor_first_name"].string
        actorLastName   = json["actor_last_name"].string
        actorPhoto      = json["actor_photo"].string
        actorId         = json["actor_id"].intValue
        path            = json["path"].string
        seen            = json["seen"].intValue == 1
        addedString     = json["added"].stringValue
        added           = ESConstant.ESDateFormatter.Default.date(from: json["added"].stringValue)
    }
}
