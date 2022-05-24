//
//  ESEndorsementUserCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/8/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESEndorsementUserCellIdentifier = "ESEndorsementUserCell"

class ESEndorsementUserCell: ESTableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgviewAvatar: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    var endorsementUser: ESEndorsmentModel! {
        didSet {
            showUserinformation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgviewAvatar.makeCircle()
        imgviewAvatar.makeBorder(width: 2, color: ESConstant.Color.Pink)
        
        viewBackground.makeRound(radius: 10)
    }
    
    fileprivate func showUserinformation() {
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if let profileURL = endorsementUser.profilePhoto, let url = URL(string: profileURL) {
            imgviewAvatar.af_setImage(withURL: url, placeholderImage: placeholder)
        } else {
            imgviewAvatar.image = placeholder
        }
        lblUsername.text = endorsementUser.firstName + " " + endorsementUser.lastName
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
