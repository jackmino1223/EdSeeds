//
//  ESProfilePreviewSkillCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/2/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESProfilePreviewSkillCellIdentifier = "ESProfilePreviewSkillCell"

class ESProfilePreviewSkillCell: ESProfilePreviewBaseCell {

    @IBOutlet weak var lblSkillName: UILabel!
    @IBOutlet weak var lblEndorseCount: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    var skill: ESStudentSkillModel! {
        didSet {
            showSkillInformation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        viewContainer.makeRound(radius: viewContainer.frame.height * 0.5)
        lblEndorseCount.makeRound(radius: lblEndorseCount.frame.height * 0.5)
        
    }
    
    fileprivate func showSkillInformation() -> Void {
        
        lblSkillName.text = skill.enName
        lblEndorseCount.text = String(skill.endorsments.count)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
