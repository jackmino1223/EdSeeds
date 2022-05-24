//
//  ESSuggestionValueCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/3/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESSuggestionValueCellIdentifier = "ESSuggestionValueCell"

class ESSuggestionValueCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        self.contentView.backgroundColor = UIColor.white
    }
    
    var check: Bool? = false {
        didSet {
            showCheck()
        }
    }
    
    fileprivate func showCheck() {
        if let checked = check {
            if checked {
                imgCheck.image = UIImage(named: "iconCkeckOption")
            } else {
                imgCheck.image = UIImage(named: "iconUnckeckOption")
            }
        } else {
            imgCheck.image = UIImage(named: "iconAddSkill")
        }
        
    }
}
