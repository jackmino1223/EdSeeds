//
//  ESNotificationBaseCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/25/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESNotificationBaseCell: ESTableViewCell {

    @IBOutlet weak var viewContentBox: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.makeCircle()
        imgAvatar.makeBorder(width: 2, color: ESConstant.Color.Pink)
        viewContentBox.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
