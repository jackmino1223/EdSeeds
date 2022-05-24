//
//  ESVideoModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESVideoModel: ESObject {

    var title: String?
    var videoDescription: String?
    var video: String?
    var photo: String?
    var addTime: Date?
    var isMain: Int = 0
    
    init(json: JSON) {
        title = json["title"].string
        videoDescription = json["description"].string
        video = json["video"].string
        photo = json["photo"].string
        addTime = ESConstant.ESDateFormatter.Default.date(from: json["add_time"].stringValue)
        isMain = json["is_main"].intValue
    }
    
    init(title t: String? = nil, description desc: String? = nil, videoPath: String?) {
        title = t
        videoDescription = desc
        video = videoPath
        addTime = Date()
    }
}
