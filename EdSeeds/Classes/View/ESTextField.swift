//
//  ESTextField.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/20/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: frame.height))
        self.leftViewMode = .always
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class ESAutoCompleteTextField: AutoCompleteTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: frame.height))
        self.leftViewMode = .always
    }

}
