//
//  ESCampaignModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESCampaignModel: ESObject {

    var cId: Int = 0
    var uId: Int = 0
    var firstName: String!
    var lastName: String!
    var major: String?
    var degree: String?
    var profilePhoto: String?
    var instName: String?
    var location: String?
    var campaignName: String!
    var createdTime: Date?
    var video: String?
    var videoId: Int?
    var photo: String?
    var details: String!
    var dueDate: String!
    var totalNeeds: Double = 0
    var totalDonors: Int = 0
    var totalPay: Double = 0
    
    var name: String?
    var videos: [ESVideoModel]?
    
    init(json: JSON) {
        cId         = json["c_id"].intValue
        uId         = json["u_id"].intValue
        firstName   = json["first_name"].stringValue
        lastName    = json["last_name"].stringValue
        major       = json["major"].string
        degree      = json["degree"].string
        profilePhoto = json["profile_photo"].string
        instName    = json["inst_name"].string
        location    = json["location"].string
        campaignName = json["campaign_name"].stringValue
        createdTime = ESConstant.ESDateFormatter.Default.date(from: json["created_time"].stringValue)
        video       = json["video"].string
        videoId     = json["video_id"].int
        photo       = json["photo"].string
        details     = json["details"].stringValue
        dueDate     = json["due_date"].stringValue
        totalNeeds  = json["total_needs"].doubleValue
        totalDonors = json["total_donors"].intValue
        totalPay    = json["total_pay"].doubleValue
        
        name        = json["name"].string
        if let jsonVideos = json["videos"].array {
            videos = []
            for jsonElem in jsonVideos {
                videos?.append(ESVideoModel(json: jsonElem))
            }
        }
    }
}
