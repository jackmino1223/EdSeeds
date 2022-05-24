//
//  ESStudnetSkillCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESStudnetSkillCellIdentifier = "ESStudnetSkillCell"

class ESStudnetSkillCell: ESTableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblSkillName: UILabel!
    @IBOutlet weak var lblEndroseCount: UILabel!
    @IBOutlet weak var imgAvatar1: UIImageView!
    @IBOutlet weak var imgAvatar2: UIImageView!
    @IBOutlet weak var imgAvatar3: UIImageView!
    @IBOutlet weak var btnEndrose: UIButton!
    
    var skill: ESStudentSkillModel! {
        didSet {
            showSkills()
        }
    }
    
    var delegate: ESStudnetSkillCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = ESConstant.Color.BorderColor
        viewBackground.makeBorder(width: 1, color: borderColor)
        btnEndrose.makeBorder(width: 1, color: borderColor)
        
        imgAvatar1.makeCircle()
        imgAvatar2.makeCircle()
        imgAvatar3.makeCircle()
        
        lblEndroseCount.makeCircle()
    }
    
    fileprivate func showSkills() {
        lblSkillName.text = skill.enName
        lblEndroseCount.text = String(skill.endorsments.count)
        var endor1: ESEndorsmentModel?
        var endor2: ESEndorsmentModel?
        var endor3: ESEndorsmentModel?
        
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if skill.endorsments.count > 0 {
            endor1 = skill.endorsments[0]
            imgAvatar1.isHidden = false
            if let profileURL = endor1!.profilePhoto, let imageURL = URL(string: profileURL) {
                imgAvatar1.af_setImage(withURL: imageURL, placeholderImage: placeholder)
            } else {
                imgAvatar1.image = placeholder
            }
        } else {
            imgAvatar1.isHidden = true
        }
        if skill.endorsments.count > 1 {
            endor2 = skill.endorsments[1]
            imgAvatar2.isHidden = false
            if let profileURL = endor2!.profilePhoto, let imageURL = URL(string: profileURL) {
                imgAvatar2.af_setImage(withURL: imageURL, placeholderImage: placeholder)
            } else {
                imgAvatar2.image = placeholder
            }

        } else {
            imgAvatar2.isHidden = true
        }
        if skill.endorsments.count > 2 {
            endor3 = skill.endorsments[2]
            imgAvatar3.isHidden = false
            if let profileURL = endor3!.profilePhoto, let imageURL = URL(string: profileURL) {
                imgAvatar3.af_setImage(withURL: imageURL, placeholderImage: placeholder)
            } else {
                imgAvatar3.image = placeholder
            }

        } else {
            imgAvatar3.isHidden = true
        }
        
        var endorsedByMe = false
        for endorse in skill.endorsments {
            if endorse.uId == ESAppManager.sharedManager.currentUser!.uId {
                endorsedByMe = true
                break
            }
        }
        
        btnEndrose.isSelected = endorsedByMe
        changeEndorseButtonState()
    }
    
    func setEnable(_ enable: Bool) -> Void {
        btnEndrose.isEnabled = enable
        if enable {
            changeEndorseButtonState()
        } else {
            btnEndrose.backgroundColor = ESConstant.Color.ViewBackground
        }
    }
    
    fileprivate func changeEndorseButtonState() {
        if btnEndrose.isSelected {
            btnEndrose.backgroundColor = ESConstant.Color.Green
        } else {
            btnEndrose.backgroundColor = UIColor.clear
        }

    }
    
    @IBAction func onPressEndorse(_ sender: Any) {
        btnEndrose.isSelected = !btnEndrose.isSelected
        changeEndorseButtonState()
        delegate?.studentSkill(cell: self, endorsed: btnEndrose.isSelected)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

protocol ESStudnetSkillCellDelegate {
    func studentSkill(cell: ESStudnetSkillCell, endorsed: Bool) -> Void
}
