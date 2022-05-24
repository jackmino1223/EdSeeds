//
//  ESCampaignsBaseVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/7/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import MZFormSheetPresentationController

class ESCampaignsBaseVC: ESTopBaseVC, UITableViewDataSource, UITableViewDelegate, ESStudentOverviewCellDelegate {

    @IBOutlet weak var tblCampaignList: UITableView!
    
    internal var campaigns: [ESCampaignModel] = []
    internal var isLoading: Bool = false

    fileprivate var prevKeyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblCampaignList.backgroundColor = ESConstant.Color.ViewBackground
        tblCampaignList.register(UINib(nibName: "ESStudentOverviewCell", bundle: nil), forCellReuseIdentifier: ESStudentOverviewCellIdentifer)
        tblCampaignList.register(UINib(nibName: "ESLoadingCell", bundle: nil), forCellReuseIdentifier: ESLoadingCellIdentifier)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCampaigns(_:)),
                                               name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                               object: nil)

        addPullToRefresh()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                  object: nil)
        removePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCampaigns(_ sender: Any) -> Void {
        loadCampaigns(keyword: prevKeyword)
    }
    
    internal func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tblCampaignList.dg_addPullToRefreshWithActionHandler({ 
            
            self.loadCampaigns(keyword: self.prevKeyword)
            
        }, loadingView: loadingView)
        tblCampaignList.dg_setPullToRefreshBackgroundColor(ESConstant.Color.ViewBackground)
        tblCampaignList.dg_setPullToRefreshFillColor(ESConstant.Color.DarkGreen)
    }
    
    internal func removePullToRefresh() {
//        tblCampaignList?.dg_removePullToRefresh()
    }
    
    internal func loadCampaigns(keyword: String?) {
        
        prevKeyword = keyword
        
        if isLoading == false {
            isLoading = true
            tblCampaignList.reloadData()
            
//            let currentUser = appManager().currentUser
            let completeClosure = { (result: [ESCampaignModel]?, errorMessage: String?) in
                
                if result != nil {
                    self.campaigns = result!
                } else {
                    self.campaigns = []
                }
                self.isLoading = false
                self.tblCampaignList.reloadData()
                
                self.tblCampaignList.dg_stopLoading()
            }
            
            if let currentUser = appManager().currentUser, currentUser.type == .donor && keyword == nil {
                var locationIds: [Int]?
                var universityIds: [Int]?
                var degreeIds: [Int]?
                var majorIds: [Int]?
                var scholarshipProgramIds: [Int]?
                if currentUser.locations.count > 0 {
                    locationIds = Array<Int>()
                    for location in currentUser.locations {
                        locationIds!.append(location.id)
                    }
                }
                if currentUser.universities.count > 0 {
                    universityIds = Array<Int>()
                    for elem in currentUser.universities {
                        universityIds!.append(elem.id)
                    }
                }
                if currentUser.degrees.count > 0 {
                    degreeIds = Array<Int>()
                    for elem in currentUser.degrees {
                        degreeIds!.append(elem.id)
                    }
                }
                if currentUser.majors.count > 0 {
                    majorIds = Array<Int>()
                    for elem in currentUser.majors {
                        majorIds!.append(elem.id)
                    }
                }
                if currentUser.scholarshipPrograms.count > 0 {
                    scholarshipProgramIds = Array<Int>()
                    for elem in currentUser.scholarshipPrograms {
                        scholarshipProgramIds!.append(elem.id)
                    }
                }
                requestManager().loadCampaign(forUser: currentUser,
                                              locationIds: locationIds,
                                              universityIds: universityIds,
                                              degreeIds: degreeIds,
                                              majorIds: majorIds,
                                              scholarshipProgramsIds: scholarshipProgramIds,
                                              complete: completeClosure)
            } else {
                requestManager().loadCampaign(forUser: appManager().currentUser, keyword: keyword, complete: completeClosure)
            }
        }

    }

    // MARK: - UITableView datasource, delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || (isLoading == false && campaigns.count == 0) {
            return 1
        } else {
            return campaigns.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading || (isLoading == false && campaigns.count == 0) {
            return 60
        } else {
            let screenWidth = UIScreen.main.bounds.width
            return screenWidth * 1.5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || (isLoading == false && campaigns.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESLoadingCellIdentifier) as! ESLoadingCell
            if isLoading {
                cell.indicatorLoading.startAnimating()
                cell.lblTitle.text = "Loading..."
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.lblTitle.text = "No result"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentOverviewCellIdentifer) as? ESStudentOverviewCell
            if cell == nil {
                
            }
            if indexPath.row % 2 == 0 {
                cell!.contentView.backgroundColor = ESConstant.Color.ViewBackground
            } else {
                cell!.contentView.backgroundColor = UIColor.white
            }
            cell!.delegate = self
            cell!.campaign = campaigns[indexPath.row]
            return cell!
        }
    }
    
    // MARK: Scroll delegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if abs(velocity.y) > 0.25 {
            appManager().activeVideoPlayer?.pause()
            print("#_$_#_$#_$_#_$_#_$#   Active Video STOPED!!!   #_$_#_$#_$_#_$_#_$#")
        }
    }
    
    private var startY: CGFloat = 0
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if abs(scrollView.contentOffset.y - startY) > 70 {
            appManager().activeVideoPlayer?.pause()
            print("*&**^*&^*&^&*^*&   Active Video STOPED!!!   **&^*^*&^*&*&^*&^*&")
        }

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    // MARK: - ESStudentOverviewCell delegate
    
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
        showProfile(campaign: cell.campaign)
//        if appManager().currentUser != nil { //, currentUser.type == .donor || currentUser.type == .advocate {
//            showProfile(campaign: cell.campaign)
//        }
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
        let blockReasonVC = self.storyboard?.instantiateViewController(withIdentifier: "ESBlockReasonTextVC") as! ESBlockReasonTextVC
        blockReasonVC.blockUsername = cell.campaign.firstName + " " + cell.campaign.lastName
        blockReasonVC.blockClousor = { (reason: String) in
            self.showLoadingIndicator()
            self.requestManager().blockUser(user: self.appManager().currentUser!, blockUserId: cell.campaign.uId, reason: reason, complete: { (result: String?) in
                self.stopLoadingIndicator()
            })
        }
        
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: blockReasonVC)
        let popupSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height - 140)
        formSheetController.presentationController?.contentViewSize = popupSize
        formSheetController.contentViewControllerTransitionStyle = .fade
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
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
    
    fileprivate func showLoginAlert() {
        /*
        self.showAlert(title: "Would you login?", message: "You can't continue because no permission. You should login to continue action. Would you login?", okButtonTitle: "OK", cancelButtonTitle: "Cancel") { 
            self.navigationController?.performSegue(withIdentifier: ESConstant.Segue.gotoLoginVC, sender: self)
        } */
        self.showSimpleAlert(title: "Warning", message: "Please login to perform this action.", dismissed: nil)
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
