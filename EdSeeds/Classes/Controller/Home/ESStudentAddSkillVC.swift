//
//  ESStudentAddSkillVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/6/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import TagListView

class ESStudentAddSkillVC: ESBaseScrollViewController, 
//                           UICollectionViewDataSource, 
//                           UICollectionViewDelegate,
//                           UICollectionViewDelegateFlowLayout,
                           UITextFieldDelegate,
                           TagListViewDelegate {

    @IBOutlet weak var txtSkillName: ESTextField!
    @IBOutlet weak var btnSearch: UIButton!
//    @IBOutlet weak var clsviewSkills: UICollectionView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var tagviewSkills: TagListView!
    @IBOutlet weak var tagviewSearchResult: TagListView!

    
    fileprivate var skills: [ESBaseObjectModel] = []
//    fileprivate var selectedSkills: [Int: Bool] = [:]
    fileprivate var userSkills: [ESBaseObjectModel] = []
    fileprivate var queryResult: [ESBaseObjectModel] = []

    fileprivate var willAddSkillObjects: [ESBaseObjectModel] = []
    fileprivate var willRemoveSkillObjects: [ESBaseObjectModel] = []
//    fileprivate var newSkills: [ESBaseObjectModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSkillName.makeBorder(width: 1, color: ESConstant.Color.BorderColor)
        btnSave.makeRound()
//        clsviewSkills.backgroundColor = ESConstant.Color.ViewBackground
        
        txtSkillName.addTarget(self, action: #selector(textFieldDidChangedText(_:)), for: .editingChanged)
        tagviewSkills.delegate = self
        tagviewSearchResult.delegate = self
        
        getSkills()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Add Skills"
    }
    
    fileprivate func getSkills() {
        
        if appManager().arraySkills != nil {
            filterSkillsForSelectedSkill()
            searchSkills(nil)
        } else {
            requestManager().getSkills(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arraySkills = result!
                    self.filterSkillsForSelectedSkill()
                    self.searchSkills(nil)
//                    self.clsviewSkills.reloadData()
                }
            })
        }
    }
    
    fileprivate func filterSkillsForSelectedSkill() {
        skills = appManager().arraySkills!
        userSkills.removeAll()
        for userSkill in appManager().currentUserSkills {
            var added: Bool = false
            for skill in skills {
                if skill.id == userSkill.id {
                    userSkills.append(skill)
                    added = true
                    break
                }
            }
            if added == false {
                userSkills.append(ESBaseObjectModel(id: userSkill.id, enName: userSkill.enName, arName: userSkill.arName))
            }
        }
        reloadUserSkillTags()
    }
    
    fileprivate func searchSkills(_ query: String?) {
        
        queryResult.removeAll()
        for skill in skills {
            if query == nil || skill.enName.lowercased().range(of: query!.lowercased()) != nil {
                var exist = false
                for userSkill in userSkills {
                    if skill.id == userSkill.id {
                        exist = true
                        break
                    }
                }
                if exist == false {
                    queryResult.append(skill)
                }
            }
        }
        if queryResult.count == 0 {
            let newSkill = ESBaseObjectModel(id: 0, enName: txtSkillName.text!, arName: "")
            queryResult.append(newSkill)
        }

        reloadSearchResultSkillTags()
    }
    
    // MARK: - UITextField delegate
    func textFieldDidChangedText(_ textfield: UITextField) -> Void {
        if textfield.text != nil && textfield.text!.characters.count == 0 {
                searchSkills(nil)
                return
        }
        searchSkills(textfield.text)
    }

    // MARK: - TagListView reload
    
    fileprivate func reloadUserSkillTags() {
        tagviewSkills.removeAllTags()
        for skill in userSkills {
            tagviewSkills.addTag(skill.enName)
        }
    }
    
    fileprivate func reloadSearchResultSkillTags() {
        tagviewSearchResult.removeAllTags()
        for skill in queryResult {
            tagviewSearchResult.addTag(skill.enName)
        }
    }
    
    // MARK: delegate
    
    /// Add Skill
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == tagviewSearchResult {
            var index: Int = 0
            for skill in queryResult {
                if skill.enName == title {
                    
                    userSkills.append(skill)
                    queryResult.remove(at: index)
                    tagviewSkills.addTag(title)
                    tagviewSearchResult.removeTag(title)
                    break
                }
                index += 1
            }
        }
    }
    
    /// Remove skill
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == tagviewSkills {
            var index: Int = 0
            for skill in userSkills {
                if skill.enName == title {
                    
                    if (txtSkillName.text!.characters.count == 0) ||
                       (txtSkillName.text!.characters.count > 0 &&
                        skill.enName.lowercased().range(of: txtSkillName.text!.lowercased()) != nil) {
                            queryResult.append(skill)
                            tagviewSearchResult.addTag(title)
                        
                    }

                    tagviewSkills.removeTag(title)
                    userSkills.remove(at: index)
                    break
                }
                index += 1
            }
        }
    }
    
    /*
    // MARK: - UICollectionView datasource, delegate, flowlayout
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if queryResult.count == 0 {
            return 1
        }
        return queryResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ESSuggestionValueCellIdentifier, for: indexPath) as! ESSuggestionValueCell
        if queryResult.count == 0 {
            cell.lblTitle.text = txtSkillName.text
            cell.check = nil
        } else {
            let skillObject = queryResult[indexPath.row]
            let title = skillObject.enName
            cell.lblTitle.text = title
            cell.check = selectedSkills[skillObject.id] ?? false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ESSuggestionValueCell

        if queryResult.count == 0 {
            
            var newSkill = ESBaseObjectModel(id: 0, enName: cell.lblTitle.text!, arName: "")
            
            
        } else {
            let skillObject = queryResult[indexPath.row]
            let selected = !(selectedSkills[skillObject.id] ?? true)
            selectedSkills[skillObject.id] = selected
            cell.check = selected
            
            if selected {
                if let index = willRemoveSkillObjects.index(of: skillObject.id) {
                    willRemoveSkillObjects.remove(at: index)
                } else {
                    willAddSkillObjects.append(skillObject.id)
                }
            } else {
                if let index = willAddSkillObjects.index(of: skillObject.id) {
                    willAddSkillObjects.remove(at: index)
                } else {
                    willRemoveSkillObjects.append(skillObject.id)
                }

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (self.view.frame.width - 40) * 0.5 - 2, height: 30)
        return cellSize
    }
    */
    
    // MARK: - Save
    
    @IBAction func onPressSave(_ sender: Any) {
        
        self.showLoadingIndicator()
        
        for skill in userSkills {
            if skill.id == 0 {
                willAddSkillObjects.append(skill)
            } else {
                var added: Bool = true
                for currentSkill in appManager().currentUserSkills {
                    if skill.id == currentSkill.id {
                        added = false
                        break
                    }
                }
                if added {
                    willAddSkillObjects.append(skill)
                }
            }
        }
        for currentSkill in appManager().currentUserSkills {
            var willRemove: Bool = true
            for skill in userSkills {
                if currentSkill.id == skill.id {
                    willRemove = false
                    break
                }
            }
            if willRemove {
                let removeSkill = ESBaseObjectModel(id: currentSkill.id, enName: currentSkill.enName, arName: currentSkill.arName)
                willRemoveSkillObjects.append(removeSkill)
            }
            
        }

        
        addSkill(index: 0)
        
    }
    
    fileprivate func addSkill(index: Int) {
        if index < willAddSkillObjects.count {
            let skill = willAddSkillObjects[index]
            if skill.id > 0 {
                requestManager().addSkill(user: appManager().currentUser!, skillId: skill.id, complete: { (errorMessage: String?) in
                    self.addSkill(index: index + 1)
                })
            } else {
                requestManager().addNewSkill(user: appManager().currentUser!, skillName: skill.enName, complete: { (errorMessage: String?) in
                    self.addSkill(index: index + 1)
                })
            }
        } else {
            removeSkill(index: 0)
        }
    }
    
    fileprivate func removeSkill(index: Int) {
        if index < willRemoveSkillObjects.count {
            let skill = willRemoveSkillObjects[index]
            requestManager().removeSkill(user: appManager().currentUser!, skillId: skill.id, complete: { (errorMessage: String?) in
                self.removeSkill(index: index + 1)
            })
        } else {
            saveComplete()
        }
    }
    
    fileprivate func saveComplete() {
        
        if willAddSkillObjects.count == 0 && willRemoveSkillObjects.count == 0 {
            _ = self.navigationController?.popViewController(animated: true)
            self.stopLoadingIndicator()
            return
        }
        
        requestManager().getStudentSkills(user: appManager().currentUser!) { (result: [ESStudentSkillModel]?, errorMessage: String?) in
            if result != nil {
                self.appManager().currentUserSkills = result!
                _ = self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.UpdatedStudentSkill), object: nil, userInfo: nil)
            } else {
                self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
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
