//
//  ESBlockReasonTextVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 4/18/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import MZFormSheetPresentationController

class ESBlockReasonTextVC: ESViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtBlockReason: KMPlaceholderTextView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var blockUsername: String = ""
    var blockClousor: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnBlock.makeRound()
        btnCancel.makeRound()
        self.lblTitle.text = "Why are you going to block\n\(blockUsername)?"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressBlock(_ sender: Any) {
        if self.txtBlockReason.text.characters.count > 10 {
            self.dismiss(animated: true, completion: { 
                if self.blockClousor != nil {
                    self.blockClousor!(self.txtBlockReason.text)
                }
            })
        } else {
            self.showSimpleAlert(title: NSLocalizedString("Warning", comment: ""),
                                 message: NSLocalizedString("You must enter 10 over characters.", comment: ""),
                                 dismissed: nil)
        }
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
