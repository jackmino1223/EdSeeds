//
//  ESVideoSelectBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/15/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class ESVideoSelectBaseVC: ESBaseScrollViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txtTitle: ESTextField!
    @IBOutlet weak var txtDescription: UITextView!

    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnCreateCampain: UIButton!

    internal var selectedVideoURL: URL?
//    internal var selectedVideoThumbnail: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        txtTitle.makeBorder(width: 1, color: borderColor)
        txtDescription.makeBorder(width: 1, color: borderColor)

        btnUpload.makeRound()
        btnCreateCampain.makeRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtTitle {
            txtDescription.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let borderColor = ESConstant.Color.BorderColor
        textField.makeBorder(width: 1, color: borderColor)
        return true
    }

    // MARK: - UITextView delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let borderColor = ESConstant.Color.BorderColor
        textView.makeBorder(width: 1, color: borderColor)
    }

    // MARK: - Button
    @IBAction func onPressUploadVideo(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let playAction = UIAlertAction(title: NSLocalizedString("Play Video", comment: ""), style: .default) { (action: UIAlertAction) in
            self.playSelectedVideo()
        }
        let deleteAction = UIAlertAction(title: NSLocalizedString("Remove Video", comment: ""), style: .default) { (action: UIAlertAction) in
            self.selectedVideoURL = nil

            self.btnUpload.backgroundColor = UIColor.lightGray
            self.btnUpload.setTitle("UPLOAD", for: .normal)

        }
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { (action: UIAlertAction) in
            self.showPicker(type: .camera)
        }
        let albumAction  = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { (action: UIAlertAction) in
            self.showPicker(type: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action: UIAlertAction) in
            
        }
        if selectedVideoURL != nil {
            actionSheet.addAction(playAction)
            actionSheet.addAction(deleteAction)
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
        
    }

    // MARK: - UIImagePicker
    
    func showPicker(type: UIImagePickerControllerSourceType) -> Void {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        if type == .camera {
            imagePicker.cameraCaptureMode = .video
        }
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let url = info[UIImagePickerControllerMediaURL] as? URL {
            selectedVideoURL = url
            // !! check the error before proceeding
            
            self.btnUpload.backgroundColor = ESConstant.Color.Green
            self.btnUpload.setTitle("SELECTED VIDEO", for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    internal func playSelectedVideo() {
        
        let player = AVPlayer(url: selectedVideoURL!)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            player.play()
        }
    }

    // Submit
    @IBAction func onPressSubmit(_ sender: Any) {
        if availableCampaignInfo() {
            submit()
        }
    }
    
    internal func availableCampaignInfo() -> Bool {
        var isAvailable = true
        
        let redBorderColor = UIColor.red
        if txtTitle.text!.characters.count == 0 {
            txtTitle.makeBorder(width: 1, color: redBorderColor)
            isAvailable = false
        }
        
        return isAvailable
    }

    internal func submit() {
    
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
