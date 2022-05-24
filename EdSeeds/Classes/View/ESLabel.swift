//
//  ESLabel.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/8/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsetsMake(5, 20, 5, 20)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
}
