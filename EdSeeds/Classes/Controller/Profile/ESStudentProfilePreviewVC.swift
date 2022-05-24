//
//  ESStudentProfilePreviewVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESStudentProfilePreviewVC: ESTableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let temp = "When you share your content with family and friends using Apple products, send gift certificates and products, or invite others to participate in Apple services or forums, Apple may collect the information you provide about those people such as name, mailing address, email address, and phone number. Apple will use such information to fulfill your requests, provide the relevant product or service, or for anti-fraud purposes."
    
    var campaign: ESCampaignModel?
    
    fileprivate let cellTitle: [Int: String] = [
        2: "Project Description :",
        3: "Dream and Mission Statement :",
        4: "Why you should fund me :",
        5: "My Social Capital :",
        6: "How I've given back",
        7: "My Blog",
        8: "My Portfolio",
        9: "Other bragging rights",
    ]
    
    fileprivate var userInformation: ESUserModel?
    fileprivate var cellDescription: [Int: String] = [:]
    fileprivate var selectedVideoIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ESStudentOverviewCell", bundle: nil), forCellReuseIdentifier: ESStudentOverviewCellIdentifer)

        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if campaign != nil {
            cellDescription[2] = campaign!.details
            getUserInformation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Information"
    }
    
    fileprivate func getUserInformation() {
        
        let refreshUserInformation = { (user: ESUserModel) in
            self.cellDescription[3] = user.statement
            self.cellDescription[4] = user.whyFund
            self.cellDescription[5] = user.socialCaptial
            self.cellDescription[6] = user.howGiveBack
            self.cellDescription[7] = user.yourBlog
            self.cellDescription[8] = user.portfolio
            self.cellDescription[9] = user.otherRights
            
        }
        
        if let currentUser = appManager().currentUser, campaign!.uId == currentUser.uId {
            userInformation = currentUser
            refreshUserInformation(userInformation!)
        } else {
            requestManager().getProfile(userId: campaign!.uId, complete: { (user: ESUserModel?, errorMessage: String?) in
                if user != nil {
                    self.userInformation = user
                    refreshUserInformation(user!)
                    self.tableView.reloadData()
                }
            })
        }
        
        requestManager().loadCampaignDetail(campaign: campaign!) { (campaignResult: ESCampaignModel?, errorMessage: String?) in
            if campaignResult != nil {
                self.campaign!.videos = campaignResult!.videos
                if let videos = campaignResult!.videos {
                    var index: Int = 0
                    for video in videos {
                        if video.isMain == 1 {
                            self.selectedVideoIndex = index
                            break
                        }
                        index += 1
                    }
                }
                
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            } else {
                
            }
        }

    }
    
    // MARK: - UITableView datasource delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let screenWidth = UIScreen.main.bounds.width
            return screenWidth * 1.5
        case 1:
            return 110
        case 5:
            return 50
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentOverviewCellIdentifer) as! ESStudentOverviewCell
            cell.btnOptions.isHidden = true
            cell.delegate = self
            if self.campaign != nil {
                cell.campaign = campaign!
            }
            return cell
            
        } else if index == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewVideoCellIdentifer) as! ESProfilePreviewVideoCell
            cell.clsviewVideos.delegate = self
            cell.clsviewVideos.dataSource = self
//            cell.clsviewVideos.reloadData()
            return cell
            
        } else if 2 <= index && index < 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewBlockCellIdentifier) as! ESProfilePreviewBlockCell
            cell.lblTitle.text = cellTitle[indexPath.row]
            cell.lblDescription.text = cellDescription[indexPath.row]
            return cell
            
        } else if index == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewBlockTitleCellIdentifier) as! ESProfilePreviewBlockTitleCell
            cell.lblTitle.text = cellTitle[indexPath.row]
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewSmallBlockCellIdentifier) as! ESProfilePreviewSmallBlockCell
            cell.lblTitle.text = cellTitle[indexPath.row]
            cell.lblDescription.text = cellDescription[indexPath.row]

            return cell
        }

    }
    
    // MARK: - UICollectionView datasource  delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaign?.videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ESStudentVideoCellIdentifier, for: indexPath) as! ESStudentVideoCell
        let videos = campaign!.videos!
        if let photoURL = videos[indexPath.row].photo {
            cell.imgviewThumbnail.sd_setImage(with: URL(string: photoURL))
        }
        cell.selectCell(indexPath.row == selectedVideoIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedVideoIndex = indexPath.row
        let video = campaign!.videos![indexPath.row]
        campaign!.video = video.video
        campaign!.photo = video.photo
        collectionView.reloadData()
        self.tableView.reloadData()
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

extension ESStudentProfilePreviewVC: ESStudentOverviewCellDelegate {
    func studentCellSeed(_ cell: ESStudentOverviewCell) {
        if let currentUser = appManager().currentUser {
            if currentUser.type == .donor  {
                
                showSeedScreen(campaign: cell.campaign)
                
            } else if currentUser.type == .advocate {
                
                self.showAlert(title: "You are advocater", message: "You should be a Donor to Seed a student Campaign. Would you like to convert to a Donor Account?", okButtonTitle: "Yes", cancelButtonTitle: "No", okClosure: {
                    self.showLoadingIndicator()
                    self.requestManager().changeAdvocateToDonor(user: self.appManager().currentUser!, complete: { (user: ESUserModel?, errorMessage: String?) in
                        
                        self.stopLoadingIndicator()
                        if user != nil {
                            self.appManager().currentUser!.type = .donor
                            self.showSeedScreen(campaign: cell.campaign)
                        } else {
                            self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
                        }
                    })
                    
                })
            }
        } else {
            showLoginAlert()
        }

    }
    
    func studentCellShare(_ cell: ESStudentOverviewCell) {
        if appManager().currentUser != nil {
            showShare(campaign: cell.campaign)
        } else {
            showLoginAlert()
        }

    }
    
    func studentCellEndrose(_ cell: ESStudentOverviewCell) {
        if appManager().currentUser != nil { //, currentUser.type == .donor || currentUser.type == .advocate {
            showEndrosement(campaign: cell.campaign)
        } else {
            showLoginAlert()
        }

    }
    
    func studentCellViewProfile(_ cell: ESStudentOverviewCell) {
        
    }
    
    func studentCellReportVideo(_ cell: ESStudentOverviewCell) {
        if appManager().arrayReportTypes != nil {
            let alertVC = UIAlertController(title: NSLocalizedString("Report Video", comment: ""),
                                            message: NSLocalizedString("Would you report this video?", comment: ""),
                                            preferredStyle: .alert)
            var videoId: Int = 0
            for video in cell.campaign.videos ?? [] {
                if video.video == cell.campaign.video {
                    videoId = cell.campaign.videoId!
                }
            }
            for reportType in appManager().arrayReportTypes! {
                let reportAction = UIAlertAction(title: NSLocalizedString(reportType.enName, comment: ""), style: .default, handler: { (action: UIAlertAction) in
                    self.showLoadingIndicator()
                    self.requestManager().reportVideo(user: self.appManager().currentUser,
                                                      videoId: videoId,
                                                      reportTypeId: reportType.id,
                                                      complete: { (result: String?) in
                                                        self.stopLoadingIndicator()
                    })
                })
                alertVC.addAction(reportAction)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action: UIAlertAction) in
                
            })
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: {
                
            })
        }

    }
    
    func studentCellBlockUser(_ cell: ESStudentOverviewCell, block: Bool) {
        
    }
    
    fileprivate func showLoginAlert() {
        /*
         self.showAlert(title: "Would you login?", message: "You can't continue because no permission. You should login to continue action. Would you login?", okButtonTitle: "OK", cancelButtonTitle: "Cancel") {
         self.navigationController?.performSegue(withIdentifier: ESConstant.Segue.gotoLoginVC, sender: self)
         } */
        self.showSimpleAlert(title: "Warning", message: "Please login to perform this action.", dismissed: nil)
    }

}
