//
//  ESBaseScrollViewController.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/4/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESBaseScrollViewController: ESViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var constraintBottomSpaceOfScrollView: NSLayoutConstraint?
    
    fileprivate var originalSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let constraint = constraintBottomSpaceOfScrollView {
            originalSpace = constraint.constant
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func keyboardWillShowRect(_ keyboardSize: CGSize) {
        constraintBottomSpaceOfScrollView?.constant = keyboardSize.height
        updateConstraintWithAnimate()
    }
    
    override func keyboardWillHideRect() {
        constraintBottomSpaceOfScrollView?.constant = originalSpace
        updateConstraintWithAnimate()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
