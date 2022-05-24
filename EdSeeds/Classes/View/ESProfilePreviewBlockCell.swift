//
//  ESProfilePreviewBlockCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESProfilePreviewBlockCellIdentifier = "ESProfilePreviewBlockCell"
let ESProfilePreviewBlockTitleCellIdentifier = "ESProfilePreviewBlockTitleCell"
let ESProfilePreviewSmallBlockCellIdentifier = "ESProfilePreviewSmallBlockCell"

class ESProfilePreviewBlockCell: ESProfilePreviewBaseCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class ESProfilePreviewBlockTitleCell: ESProfilePreviewBaseCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
    }

}

class ESProfilePreviewSmallBlockCell: ESProfilePreviewBaseCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
    }

}
