//
//  ESBaseObjectModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESBaseObjectModel: ESObject {

    var id: Int = 0
    var enName: String!
    var arName: String!
    
    init(json: JSON) {
        super.init()
        id = json["id"].intValue
        enName = json["en_name"].stringValue
        arName = json["ar_name"].stringValue
    }

    init(json: JSON, idFieldName: String) {
        id = json[idFieldName].intValue
        enName = json["en_name"].stringValue
        arName = json["ar_name"].stringValue
    }
    
    init(id _id: Int, enName _enName: String, arName _arName: String) {
        id = _id
        enName = _enName
        arName = _arName
    }
    
}
