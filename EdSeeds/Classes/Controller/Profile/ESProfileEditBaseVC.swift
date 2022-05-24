//
//  ESProfileEditBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/8/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESProfileEditBaseVC: ESTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgviewAvatar: UIImageView!
    @IBOutlet weak var btnEditAvatar: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnSaveProfile: UIButton!
    
    
    internal var isEditingProfile: Bool = true
    internal var selectedImage: UIImage?
    var isEditedProfile: Bool = false
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        imgviewAvatar.makeCircle()
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if let url = appManager().currentUser!.profilePhoto, let imageURL = URL(string: url) {
            imgviewAvatar.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        } else {
            imgviewAvatar.image = placeholder
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Profile"
    }

    
    
    internal func getUserInformation() {
        
    }
    
    // MARK: - Edit
    
    @IBAction func onPressSaveProfile(_ sender: Any) {
        if isEditedProfile {
            self.isEditedProfile = false
            saveProfile(complete: { (success: Bool) in
                if success {
                    
                    self.getUserInformation()
                    
                    self.tableView.reloadData()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                    object: nil, userInfo: nil)
                    
                } else {
                    self.isEditedProfile = true
                }
            })
        }
    }
    
    /*
    @IBAction func onPressEditProfile(_ sender: Any) {
        if isEditingProfile {
            
            saveProfile(complete: { (success: Bool) in
                if success {
                    
                    self.isEditingProfile = false
//                    self.btnEditProfile.isSelected = self.isEditingProfile
                    
//                    self.btnCancelProfile.isHidden = true
                    self.getUserInformation()
                    
//                    self.resetTempararyValues()
                    
                    self.tableView.reloadData()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                    object: nil, userInfo: nil)

                } else {
                    
                }
            })
            
        } else {
            isEditingProfile = true
            
//            self.btnEditProfile.isSelected = self.isEditingProfile
            
//            self.btnCancelProfile.isHidden = false
            
            tableView.reloadData()
        }
    }
    
    @IBAction func onPressCancelEditProfile(_ sender: Any) -> Void {
        
        isEditingProfile = false
        
//        self.btnCancelProfile.isHidden = true
//        self.btnEditProfile.isSelected = false
        resetTempararyValues()
        tableView.reloadData()
    } */
    
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
    
    internal func saveProfile(complete: @escaping ((Bool) -> Void)) {
        let params: [String: Any] = parametersToSave()
        
        showLoadingIndicator()
        
        if params.count > 0 {
            requestManager().editProfile(user: appManager().currentUser!, extraParams: params) { (user: ESUserModel?, errorMessage: String?) in
                if user != nil {
                    user!.token = self.appManager().currentUser!.token
                    self.appManager().currentUser = user!
                    
                    self.updateProfilePhoto(complete: { (success: Bool) in
                        complete(success)
                    })
                    
                } else {
                    complete(false)
                    self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
                    self.stopLoadingIndicator()
                }
            }
        } else {
            self.updateProfilePhoto(complete: { (success: Bool) in
                complete(success)
            })
        }
    }
    
    internal func updateProfilePhoto(complete: @escaping ((Bool) -> Void)) {
        if self.selectedImage != nil {
            self.requestManager().changeUserAvatar(user: self.appManager().currentUser!,
                                                   avatar: self.selectedImage!,
                                                   complete: { (avatarUser: ESUserModel?, avatarError: String?) in
                                                    if avatarUser != nil {
                                                        self.appManager().currentUser!.profilePhoto = avatarUser!.profilePhoto
                                                        
                                                    }
                                                    
                                                    self.stopLoadingIndicator()
                                                    complete(true)
                                                    
            })
        } else {
            self.stopLoadingIndicator()
            complete(true)
        }

    }
    
    internal func parametersToSave() -> [String: Any] {
        return [:]
    }
    
    internal func resetTempararyValues() {
        
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
    
    // MARK: UIImagePickerController delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imgviewAvatar.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
        self.isEditedProfile = true
    }
    
    
    // MARK: - Logout
    
    @IBAction func onPressLogout(_ sender: Any) {
        print ("logout")
        
        showLoadingIndicator()
        
        requestManager().logout { (errorMessage: String?) in
            if errorMessage == nil {
                
                let mainTabVC = self.tabBarController as! ESMainTabVC
                mainTabVC.logout()
                
            } else {
                
                self.showSimpleAlert(title: "Error", message: errorMessage!, dismissed: nil)
                
            }
            self.stopLoadingIndicator()
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
