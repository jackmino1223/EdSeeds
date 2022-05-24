//
//  ESStudentHomeVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices
import MBProgressHUD
import SwiftyJSON
import DGElasticPullToRefresh

class ESStudentHomeVC: ESTopBaseVC,
                        UITableViewDataSource,
                        UITableViewDelegate,
                        ESStudentOverviewCellDelegate,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegate {

    @IBOutlet weak var viewMainContainer: UIView!
    
    @IBOutlet weak var viewUserInfoContainer: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var viewStartNewCampain: UIView!
    @IBOutlet weak var viewAddSkills: UIView!
    @IBOutlet weak var viewShareProfile: UIView!
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnLinkedin: UIButton!
    @IBOutlet weak var btnGoogle:   UIButton!
    
    fileprivate var studentCampaigns: [ESCampaignModel] = []
    
    fileprivate var tblCampaigns: UITableView?
    fileprivate var selectedVideoIndex: Int = -1
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        imgAvatar.makeCircle()
        imgAvatar.makeBorder(width: 2, color: ESConstant.Color.Pink)
        
        viewStartNewCampain.makeRound(radius: 10)
        viewAddSkills.makeRound(radius: 10)
        
        let tapNewCampain = UITapGestureRecognizer(target: self, action: #selector(onPressStartNewCampain(_:)))
        viewStartNewCampain.addGestureRecognizer(tapNewCampain)
        
        let tapAddSkill = UITapGestureRecognizer(target: self, action: #selector(onPressEditSkill(_:)))
        viewAddSkills.addGestureRecognizer(tapAddSkill)
        
        viewMainContainer.isHidden = true
        
        showUserInfo()
        loadCampaigns(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadCampaigns(_:)),
                                               name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCampaigns(_:)),
                                               name: NSNotification.Name(rawValue: ESConstant.Notification.AddedNewVideo),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCampaigns(_:)),
                                               name: NSNotification.Name(rawValue: ESConstant.Notification.UpdatedStudentSkill),
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(loadCampaigns(_:)),
//                                               name: NSNotification.Name(rawValue: ESConstant.Notification.UpdatedProfileInfo),
//                                               object: nil)
//        addPullToRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.AddedNewVideo),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.UpdatedStudentSkill),
                                                  object: nil)
//        NotificationCenter.default.removeObserver(self,
//                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.UpdatedProfileInfo),
//                                                  object: nil)
//        removePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Home"
    }
    
    internal func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = ESConstant.Color.Green
        tblCampaigns?.dg_addPullToRefreshWithActionHandler({
            
            self.loadCampaigns(self)
            
        }, loadingView: loadingView)
        tblCampaigns?.dg_setPullToRefreshBackgroundColor(ESConstant.Color.ViewBackground)
        tblCampaigns?.dg_setPullToRefreshFillColor(UIColor.white)
    }
    
    internal func removePullToRefresh() {
        tblCampaigns?.dg_removePullToRefresh()
    }

    func onPressStartNewCampain(_ sender: Any) -> Void {
//        let newCampainVC = self.storyboard?.instantiateViewController(withIdentifier: "ESStudentNewCampainVC") as! ESStudentNewCampainVC
//        
//        self.tabBarController?.navigationController?.pushViewController(newCampainVC, animated: true)
        
        self.performSegue(withIdentifier: ESConstant.Segue.gotoStudentNewCampainVC, sender: self)
    }
    
    func onPressAddSkill(_ sender: Any) -> Void {
        
    }
    
    @IBAction func onPressShareSocial(_ sender: Any) {
        let tempCampaign = ESCampaignModel(json: JSON(["u_id": appManager().currentUser!.uId]))
        showShare(campaign: tempCampaign)
        
    }
    
    // MARK: - Student information
    
    fileprivate func showUserInfo() {
        let currentUser = appManager().currentUser!
        
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if let url = currentUser.profilePhoto, let imageURL = URL(string: url) {
            imgAvatar.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        } else {
            imgAvatar.image = placeholder
        }
        lblUsername.text = currentUser.fullName
    }
    
    @objc fileprivate func loadCampaigns(_ sender: Any) {
        showLoadingIndicator()
        if sender is Notification {
            showUserInfo()
        }
        requestManager().loadCampaign(forUser: appManager().currentUser!) { (result: [ESCampaignModel]?, errorMessage: String?) in
            if result != nil {
                
                self.studentCampaigns = result!
                
                if self.studentCampaigns.count > 0 {
                    
                    self.showCampaigns()
                    
                }
                
            } else {
                self.viewMainContainer.isHidden = false
            }
            
            self.loadSkills()

            self.stopLoadingIndicator()
            self.tblCampaigns?.dg_stopLoading()
            
        }

    }
    
    @objc fileprivate func showCampaigns(_ sender: Any? = nil) {
        
        if tblCampaigns == nil {
            let profilePreviewVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentProfilePreviewVC") as! ESStudentProfilePreviewVC
            tblCampaigns = profilePreviewVC.tableView
            
            tblCampaigns!.estimatedRowHeight = 130
            tblCampaigns!.rowHeight = UITableViewAutomaticDimension
            tblCampaigns!.register(UINib(nibName: "ESStudentOverviewCell", bundle: nil), forCellReuseIdentifier: ESStudentOverviewCellIdentifer)
            tblCampaigns!.dataSource = self
            tblCampaigns!.delegate = self
            
            addPullToRefresh()
            
            /*
            let titleCell = tblCampaigns!.dequeueReusableCell(withIdentifier: ESProfilePreviewSectionTitleCellIdentifier) as! ESProfilePreviewSectionTitleCell
            titleCell.lblTitle.text = NSLocalizedString("My Fundraising Campaigns", comment: "")
            titleCell.btnEdit.addTarget(self, action: #selector(onPressEditMyfundraisingCampaigns(_:)), for: .touchUpInside)
            tblCampaigns!.tableHeaderView = titleCell.contentView  */
        }
        
        if studentCampaigns.count > 0 {
            
            self.viewMainContainer.isHidden = true
            
            if tblCampaigns!.superview == nil || tblCampaigns!.superview != self.view {
                tblCampaigns?.removeFromSuperview()
                
                self.view.addSubview(tblCampaigns!)
                
                tblCampaigns!.snp.makeConstraints { (maker: ConstraintMaker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(self.viewUserInfoContainer.snp.bottom).offset(0)
                    maker.bottom.equalTo((self.bottomLayoutGuide as! UIView).snp.top).offset(-10)
                }
            }
            
            tblCampaigns!.reloadData()
            
        } else if appManager().currentUserSkills.count > 0 {
            
            self.viewMainContainer.isHidden = false
            self.viewAddSkills.isHidden = true
            self.viewShareProfile.isHidden = true
            
            if tblCampaigns!.superview == nil || tblCampaigns!.superview != self.viewMainContainer {
                tblCampaigns?.removeFromSuperview()
                
                self.viewMainContainer.addSubview(tblCampaigns!)
                
                tblCampaigns!.snp.makeConstraints { (maker: ConstraintMaker) in
                    maker.left.right.bottom.equalToSuperview()
                    maker.top.equalTo(self.viewStartNewCampain.snp.bottom).offset(20)
                }
            }

            tblCampaigns!.reloadData()
            
        } else {
            
            self.viewMainContainer.isHidden = false
            self.viewAddSkills.isHidden = false
            self.viewShareProfile.isHidden = false

            if tblCampaigns!.superview != nil {
                tblCampaigns!.removeFromSuperview()
            }
        }
        
    }

    fileprivate func loadSkills() {
        
        requestManager().getStudentSkills(user: appManager().currentUser!) { (result: [ESStudentSkillModel]?, errorMessage: String?) in
            if result != nil {
                self.appManager().currentUserSkills = result!
//                self.tblCampaigns?.reloadData()
                self.showCampaigns()
            }
            self.loadCampaignDetail()
        }
        
    }
    
    fileprivate func loadCampaignDetail() {
        if self.studentCampaigns.count > 0 {
            let campaign = self.studentCampaigns[0]
            requestManager().loadCampaignDetail(campaign: campaign) { (campaignResult: ESCampaignModel?, errorMessage: String?) in
                if campaignResult != nil {
                    self.studentCampaigns[0].videos = campaignResult!.videos
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
                    
                    self.showCampaigns()
                } else {
                    
                }
            }
        }
    }
    
    @objc fileprivate func updatedSkills(_ sender: Any) {
        self.tblCampaigns?.reloadData()
    }
    
    // MARK: - UITableView datasource delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return studentCampaigns.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < studentCampaigns.count {
            return 3
        } else {
            var count = appManager().currentUserSkills.count
            if count == 0 {
                count = 1
            }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < studentCampaigns.count {
            if indexPath.row == 0 {
                let screenWidth = UIScreen.main.bounds.width
                return screenWidth * 1.2
            } else if indexPath.row == 1 {
                return 110
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        /*
        if section == studentCampaigns.count {
            return 50
        } else {
            return 0
        } */
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewSectionTitleCellIdentifier) as! ESProfilePreviewSectionTitleCell

        if section == studentCampaigns.count {
            titleCell.lblTitle.text = NSLocalizedString("My Skills and Endorsement", comment: "")
            titleCell.btnEdit.addTarget(self, action: #selector(onPressEditSkill(_:)), for: .touchUpInside)

        } else {

            titleCell.lblTitle.text = NSLocalizedString("My Fundraising Campaigns", comment: "")
            titleCell.btnEdit.addTarget(self, action: #selector(onPressEditMyfundraisingCampaigns(_:)), for: .touchUpInside)
            
        }
        
        titleCell.btnEdit.tag = 200 + section
        return titleCell.contentView
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < studentCampaigns.count {
            
            let campaign = studentCampaigns[indexPath.section]
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentOverviewCellIdentifer) as! ESStudentOverviewCell
                cell.hideUserInfo()
                cell.campaign = campaign
                cell.delegate = self
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewVideoCellIdentifer) as! ESProfilePreviewVideoCell
                cell.clsviewVideos.delegate = self
                cell.clsviewVideos.dataSource = self
                cell.clsviewVideos.reloadData()
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewBlockCellIdentifier) as! ESProfilePreviewBlockCell
                cell.lblDescription.text = String(format: "%@\n\n%@", campaign.campaignName, campaign.details)
                return cell
                
            }
        } else {
            
            if appManager().currentUserSkills.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ESProfilePreviewSkillCellIdentifier) as! ESProfilePreviewSkillCell
                cell.skill = appManager().currentUserSkills[indexPath.row]
                return cell
            } else {
                let cellIdentifier = "skillEmptyDescriptionCell"
                var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
                    cell!.textLabel?.font = UIFont(name: ESConstant.FontName.Italic, size: 13)
                    cell!.textLabel?.textColor = ESConstant.Color.GrayFontColor
                    cell!.textLabel?.text = "Add some skills to your profile."
                    cell!.contentView.backgroundColor = ESConstant.Color.ViewBackground
                }
                return cell!
            }
        }

        
    }
    
    // MARK: OverviewCell delegate
    
    func studentCellSeed(_ cell: ESStudentOverviewCell) {
        self.performSegue(withIdentifier: ESConstant.Segue.gotoStudentAddNewVideoVC, sender: self)
    }
    
    func studentCellShare(_ cell: ESStudentOverviewCell) {
        
    }
    
    func studentCellEndrose(_ cell: ESStudentOverviewCell) {
        
    }
    
    func studentCellViewProfile(_ cell: ESStudentOverviewCell) {
        
    }
    
    func studentCellReportVideo(_ cell: ESStudentOverviewCell) {

    }
    
    func studentCellBlockUser(_ cell: ESStudentOverviewCell, block: Bool) {
        
    }


    // MARK: Edit actions
    func onPressEditMyfundraisingCampaigns(_ sender: Any) -> Void {
        if let button = sender as? UIButton {
            let sectionIndex = button.tag - 200
            let campaign = studentCampaigns[sectionIndex]
            
            let editCampaignVC = self.storyboard!.instantiateViewController(withIdentifier: "ESStudentNewCampainVC") as! ESStudentNewCampainVC
            editCampaignVC.setEditingMode(originalCampaign: campaign)
            self.navigationController?.pushViewController(editCampaignVC, animated: true)
            
        }
    }
    
    func onPressEditSkill(_ sender: Any) -> Void {
        self.performSegue(withIdentifier: ESConstant.Segue.gotoStudentAddSkillVC, sender: self)
    }
    
    // MARK: - UICollectionView datasource, delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.studentCampaigns.count > 0 {
            if let videos = self.studentCampaigns[0].videos {
                return videos.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ESStudentVideoCellIdentifier, for: indexPath) as! ESStudentVideoCell
        let videos = self.studentCampaigns[0].videos!
        if let photoURL = videos[indexPath.row].photo {
            cell.imgviewThumbnail.sd_setImage(with: URL(string: photoURL))
            /*
            ESThumbnailManager.sharedManager.getThumbnail(url: videoURL, complete: { (image: UIImage?) in
                cell.imgviewThumbnail.image = image
            }) */
        }
        cell.selectCell(indexPath.row == selectedVideoIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedVideoIndex = indexPath.row
        let video = self.studentCampaigns[0].videos![indexPath.row]
        self.studentCampaigns[0].video = video.video
        self.studentCampaigns[0].photo = video.photo
        collectionView.reloadData()
        tblCampaigns?.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == ESConstant.Segue.gotoStudentAddNewVideoVC {
                let vc = segue.destination as! ESStudentAddNewVideoVC
                vc.campaign = self.studentCampaigns[0]
            }
        }
    }
    
    // MARK: - from Notification
    func showFromNotification(_ notification: ESNotificationModel) -> Void {
        var indexPath: IndexPath? = nil
        if notification.notType == 5 {
            indexPath = IndexPath(row: 0, section: studentCampaigns.count)
        } else {
            var index: Int = 0
            
            for campaign in studentCampaigns {
                if campaign.cId == notification.targetId {
                    indexPath = IndexPath(row: 0, section: index)
                    break
                }
                index += 1
            }
        }
        if indexPath != nil {
            tblCampaigns?.scrollToRow(at: indexPath!, at: .top, animated: true)
        }
    }
}
