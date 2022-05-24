//
//  ESCountryModel.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/31/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ESCountryModel: ESBaseObjectModel {

    var prefix: String!
    
    override init(json: JSON) {
        super.init(json: json)
        prefix = json["prefix"].stringValue
    }
 
}
