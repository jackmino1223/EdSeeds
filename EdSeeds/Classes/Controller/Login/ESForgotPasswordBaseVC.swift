//
//  ESForgotPasswordBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/15/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESForgotPasswordBaseVC: ESViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textfield0: ESTextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    var registeredEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor =  ESConstant.Color.BorderColor
        textfield0.makeBorder(width: 1, color: borderColor)
        textfield0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        lblWarning.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(_ textField: UITextField) -> Void {
        self.lblWarning.isHidden = true
        if textField == textfield0 {
            self.textfield0.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textfield0 {
            textfield0.resignFirstResponder()
            onPressNext(btnNext)
        }
        return false
    }

    
    @IBAction func onPressNext(_ sender: Any) {
        if availableInfo() {
            submit()
        }
    }

    internal func submit() {
        
    }
    
    internal func availableInfo() -> Bool {
        return true
    }
    
    internal func submitting(_ loading: Bool) {
        if loading {
            self.indicatorLoading.startAnimating()
            self.btnNext.isEnabled = false
            self.navigationController!.view.isUserInteractionEnabled = false
        } else {
            self.indicatorLoading.stopAnimating()
            self.btnNext.isEnabled = true
            self.navigationController!.view.isUserInteractionEnabled = true
        }
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
