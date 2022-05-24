//
//  ESEndrosementVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class ESEndrosementVC: ESTableViewController, ESStudnetSkillCellDelegate {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnAddSkill: UIButton!
    
    var userCampaign: ESCampaignModel?
    fileprivate var isLoading: Bool = false
    fileprivate var userSkills: [ESStudentSkillModel] = []
    fileprivate var isChangingEndorse: [Bool] = []
    fileprivate var noSkillMessage = "No skills Available"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnAddSkill.makeRound()
        btnAddSkill.isHidden = true
        
        let fullname = String(format: "%@ %@", userCampaign!.firstName, userCampaign!.lastName)
        let title = String(format: "Endorse %@ for these skills", fullname)
        let attrTitle = NSMutableAttributedString(string: title)
        
        let boldFont = UIFont(name: ESConstant.FontName.Bold, size: 14)!
        let usernameRange = NSMakeRange(8, fullname.characters.count)
        
        attrTitle.addAttributes([NSForegroundColorAttributeName : ESConstant.Color.Green,
                                 NSFontAttributeName: boldFont], range: usernameRange)
        lblUsername.attributedText = attrTitle
        
        tableView.register(UINib(nibName: "ESLoadingCell", bundle: nil), forCellReuseIdentifier: ESLoadingCellIdentifier)
        
        loadStudentSkills()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Endoresment"
    }

    fileprivate func loadStudentSkills() {
        if isLoading == false {
            isLoading = true
            tableView.reloadData()
            requestManager().getStudentSkills(studentId: userCampaign!.uId, complete: { (result: [ESStudentSkillModel]?, errorMessage: String?) in
                if result != nil {
                    self.userSkills = result!
                    self.isChangingEndorse = Array(repeating: false, count: result!.count)
                } else {
                    self.noSkillMessage = errorMessage!
                }
                self.isLoading = false
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - UITableView datasource delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || (isLoading == false && userSkills.count == 0) {
            return 1
        } else {
            return userSkills.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || (isLoading == false && userSkills.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESLoadingCellIdentifier) as! ESLoadingCell
            if isLoading {
                cell.indicatorLoading.startAnimating()
                cell.lblTitle.text = "Loading..."
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.lblTitle.text = noSkillMessage
            }
            cell.contentView.backgroundColor = ESConstant.Color.ViewBackground
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudnetSkillCellIdentifier) as! ESStudnetSkillCell
            cell.skill = userSkills[indexPath.row]
            cell.delegate = self
            cell.setEnable(!self.isChangingEndorse[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let endorsements = userSkills[indexPath.row].endorsments
        if endorsements.count > 0 {
            let endorsementListVC = self.storyboard?.instantiateViewController(withIdentifier: "ESEndorsementListVC") as! ESEndorsementListVC
            endorsementListVC.endorsements = endorsements
            let formSheetController = MZFormSheetPresentationViewController(contentViewController: endorsementListVC)
            let popupSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height - 140)
            formSheetController.presentationController?.contentViewSize = popupSize
            formSheetController.contentViewControllerTransitionStyle = .fade
            formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
            
            self.present(formSheetController, animated: true, completion: nil)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: ESStudnetSkillCell delegate
    func studentSkill(cell: ESStudnetSkillCell, endorsed: Bool) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            isChangingEndorse[indexPath.row] = true
            self.tableView.reloadData()
            let currentUser = appManager().currentUser!
            let userSkill = userSkills[indexPath.row]
            requestManager().endorseSkill(user: currentUser, studentSkill: userSkill, endorse: endorsed, complete: { (errorMessage: String?) in
                if errorMessage == nil {
                    if endorsed {
                        let endorsement = ESEndorsmentModel(firstName: currentUser.firstName,
                                                            lastName: currentUser.lastName,
                                                            userId: currentUser.uId,
                                                            profilePhoto: currentUser.profilePhoto)
                        userSkill.endorsments.append(endorsement)
                    } else {
                        var index: Int = 0
                        for endorsement in userSkill.endorsments {
                            if endorsement.uId == currentUser.uId {
                                userSkill.endorsments.remove(at: index)
                                break
                            }
                            index += 1
                        }
                    }
                } else {
                    
                }
                self.isChangingEndorse[indexPath.row] = false
                self.tableView.reloadData()
            })
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
