//
//  ESJoinAsStudentAvatarVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/20/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import QuartzCore
import KMPlaceholderTextView

class ESJoinAsStudentAvatarVC: ESBaseScrollViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblChangeProfilePicture: UILabel!
    @IBOutlet weak var btnEditAvatar: UIButton!
    @IBOutlet weak var txtLifeDream: KMPlaceholderTextView!
    @IBOutlet weak var txtDonorFund: KMPlaceholderTextView!
    @IBOutlet weak var btnNext: UIButton!
    
    fileprivate var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.makeCircle()
        let borderColor = ESConstant.Color.BorderColor
        txtLifeDream.makeBorder(width: 1, color: borderColor)
        txtDonorFund.makeBorder(width: 1, color: borderColor)
        
        btnNext.makeRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "JOIN AS STUDENT"
    }
    
    // MARK: - Image Picker
    
    @IBAction func onPressEditAvatar(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { (action: UIAlertAction) in
            self.showPicker(type: .camera)
        }
        let albumAction  = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { (action: UIAlertAction) in
            self.showPicker(type: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action: UIAlertAction) in
            
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showPicker(type: UIImagePickerControllerSourceType) -> Void {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        if type == .camera {
            imagePicker.cameraCaptureMode = .photo
        }
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imgAvatar.image = selectedImage
        lblChangeProfilePicture.isHidden = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Next
    
    @IBAction func onPressNext(_ sender: Any) {
        
        appManager().registeringUserPhoto = selectedImage
        
        let registeringUser = appManager().registeringUser
        registeringUser!.statement = txtLifeDream.text
        registeringUser!.whyFund   = txtDonorFund.text
        
        self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsStudentSocialCapitalVC, sender: self)
        
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
