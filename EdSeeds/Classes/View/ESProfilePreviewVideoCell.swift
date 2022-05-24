//
//  ESProfilePreviewVideoCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

let ESProfilePreviewVideoCellIdentifer = "ESProfilePreviewVideoCell"

class ESProfilePreviewVideoCell: ESProfilePreviewBaseCell {

    @IBOutlet weak var clsviewVideos: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
