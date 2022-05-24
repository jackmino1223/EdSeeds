//
//  ESView.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIView {
    
    func makeRound(radius: CGFloat = 5) -> Void {
        self.layer.cornerRadius = radius
    }
    
    func makeCircle() -> Void {
        self.layer.cornerRadius = self.frame.width * 0.5
    }
    
    func makeBorder(width: CGFloat, color: UIColor) -> Void {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}
