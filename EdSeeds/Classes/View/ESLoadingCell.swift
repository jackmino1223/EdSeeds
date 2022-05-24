//
//  ESLoadingCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/7/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESLoadingCellIdentifier = "ESLoadingCell"

class ESLoadingCell: ESTableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ESConstant.Color.ViewBackground
        self.contentView.backgroundColor = ESConstant.Color.ViewBackground
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
