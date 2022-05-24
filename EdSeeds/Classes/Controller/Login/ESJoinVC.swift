//
//  ESJoinVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESJoinVC: ESViewController {

    @IBOutlet weak var viewDonor: UIView!
    @IBOutlet weak var viewStudent: UIView!
    @IBOutlet weak var viewAdvocate: UIView!
    
    @IBOutlet weak var constraintVSpace1: NSLayoutConstraint!
    @IBOutlet weak var constraintVSpace2: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewDonor.makeRound(radius: 10)
        viewStudent.makeRound(radius: 10)
        viewAdvocate.makeRound(radius: 10)
        
        let tapDonor = UITapGestureRecognizer(target: self, action: #selector(onPressDonor(_:)))
        viewDonor.addGestureRecognizer(tapDonor)
        
        let tapStudent = UITapGestureRecognizer(target: self, action: #selector(onPressStudent(_:)))
        viewStudent.addGestureRecognizer(tapStudent)
        
        let tapAdvocate = UITapGestureRecognizer(target: self, action: #selector(onPressAdvocate(_:)))
        viewAdvocate.addGestureRecognizer(tapAdvocate)
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight <= 480 {
            constraintVSpace1.constant = 8
            constraintVSpace2.constant = 8
            updateConstraintWithAnimate(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "JOIN"
    }
    
    func onPressDonor(_ sender: Any) -> Void {
        self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsDonorVC, sender: true)
    }
    
    func onPressStudent(_ sender: Any) -> Void {
        self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsStudentVC, sender: sender)
    }
    
    func onPressAdvocate(_ sender: Any) {
        self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsDonorVC, sender: false)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == ESConstant.Segue.gotoJoinAsDonorVC {
                if let isDonor = sender as? Bool {
                    let joinDonorVC = segue.destination as! ESJoinAsDonorVC
                    joinDonorVC.isDonorAccount = isDonor
                }
            }
        }
    }
    

}
