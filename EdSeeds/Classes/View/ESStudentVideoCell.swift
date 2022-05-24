//
//  ESStudentVideoCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESStudentVideoCellIdentifier = "ESStudentVideoCell"

class ESStudentVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgviewThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = ESConstant.Color.Green.cgColor
        imgviewThumbnail.contentMode = .scaleAspectFit
    }
    
    func selectCell(_ select: Bool) -> Void {
        if select {
            self.layer.borderWidth = 2
        } else {
            self.layer.borderWidth = 0
        }
    }
}
