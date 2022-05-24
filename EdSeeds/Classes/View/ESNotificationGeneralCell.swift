//
//  ESNotificationGeneralCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/25/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESNotificationGeneralCellIdentifier = "ESNotificationGeneralCell"

class ESNotificationGeneralCell: ESNotificationBaseCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var notification: ESNotificationModel! {
        didSet {
            showNotification()
        }
    }
    
    fileprivate func showNotification() {
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        imgAvatar.image = placeholder
        if notification.actorPhoto != nil && notification.path != nil {
            let fullPath = notification.path! + notification.actorPhoto!
            if let imageURL = URL(string: fullPath) {
                imgAvatar.af_setImage(withURL: imageURL, placeholderImage: placeholder)
            }
        }
        
        lblDescription.text = notification.msgDescription
        lblTime.text = notification.addedString

    }

}
