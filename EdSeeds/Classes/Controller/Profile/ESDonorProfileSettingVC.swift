//
//  ESDonorProfileSettingVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESDonorProfileSettingVC: ESProfileEditBaseVC,
                                ESStudentProfileField1CellDelegate {

    
    fileprivate var fields: [[String: Any]] = [
        [ // 0
            fieldTitle : "First Name",
            fieldType : 10,
            parameterName : "first_name",
            ],
        [ // 1
            fieldTitle : "Last Name",
            fieldType : 10,
            parameterName : "last_name",
            ],
        ]
    
    fileprivate var tempararyValues: [String?] = Array(repeating: nil, count: 7)
    fileprivate var tempararySelectedOptions: [Int: [ESBaseObjectModel]] = [:]
    
    fileprivate var suggestionValues: [Int: [ESBaseObjectModel]] = [:]
    fileprivate var editingCell: [Int: Bool] = [:]
    
    // MARK: 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        getUserInformation()
        getSuggestionValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func getUserInformation() {
        let currentUser = appManager().currentUser!
        
        fields[0][fieldText] = currentUser.firstName
        fields[1][fieldText] = currentUser.lastName
        
        tempararyValues[0] = currentUser.firstName
        tempararyValues[1] = currentUser.lastName

        if currentUser.type == .donor {
            fields.append(contentsOf: [
                [ // 2
                    fieldTitle : "Location",
                    fieldType : 20,
                    parameterName : "location",
                    ],
                [ // 3
                    fieldTitle : "University",
                    fieldType : 20,
                    parameterName : "university",
                    ],
                [ // 4
                    fieldTitle : "Degree",
                    fieldType : 20,
                    parameterName : "degree",
                    ],
                [ // 5
                    fieldTitle : "Major",
                    fieldType : 20,
                    parameterName : "major",
                    ],
                [ // 6
                    fieldTitle : "Scholarship Program",
                    fieldType : 20,
                    parameterName : "scholarship_prg",
                    ],
                ])
            
            let addTempararyValues = { (index: Int, originValues: [ESBaseObjectModel]) in
                self.tempararySelectedOptions[index] = []
                self.tempararySelectedOptions[index]!.append(contentsOf: originValues)
            }
            
            fields[2][fieldText] = currentUser.locations
            addTempararyValues(2, currentUser.locations)
            
            fields[3][fieldText] = currentUser.universities
            addTempararyValues(3, currentUser.universities)

            fields[4][fieldText] = currentUser.degrees
            addTempararyValues(4, currentUser.degrees)

            fields[5][fieldText] = currentUser.majors
            addTempararyValues(5, currentUser.majors)

            fields[6][fieldText] = currentUser.scholarshipPrograms
            addTempararyValues(6, currentUser.scholarshipPrograms)

            /*
            if currentUser.locations.count > 0 {
                fields[2][fieldText] = currentUser.locations //joinedString(ofArray: currentUser.locations)
                addTempararyValues(2, currentUser.locations)
            } else {
                fields[2][fieldText] = ""
            }
            
            if currentUser.universities.count > 0 {
                fields[3][fieldText] = currentUser.universities //joinedString(ofArray: currentUser.universities)
                addTempararyValues(3, currentUser.universities)
            } else {
                fields[3][fieldText] = ""
            }
            if currentUser.degrees.count > 0 {
                fields[4][fieldText] = currentUser.degrees //joinedString(ofArray: currentUser.degrees)
                addTempararyValues(4, currentUser.degrees)
            } else {
                fields[4][fieldText] = ""
            }
            if currentUser.majors.count > 0 {
                fields[5][fieldText] = currentUser.majors // joinedString(ofArray: currentUser.majors)
                addTempararyValues(5, currentUser.majors)
            } else {
                fields[5][fieldText] = ""
            }
            if currentUser.scholarshipPrograms.count > 0 {
                fields[6][fieldText] = joinedString(ofArray: currentUser.scholarshipPrograms)
                addTempararyValues(6, currentUser.scholarshipPrograms)
            } else {
                fields[6][fieldText] = ""
            } */

        }
    }
    
    private func joinedString(ofArray values: [ESBaseObjectModel]) -> String? {
        let result = values.map({ (elem: ESBaseObjectModel) -> String in
            return elem.enName
        }).joined(separator: ", ")
        return result
    }
    
    private func joinedIds(ofArray values: [ESBaseObjectModel]) -> String? {
        let result = values.map({ (elem: ESBaseObjectModel) -> String in
            return String(elem.id)
        }).joined(separator: ",")
        return result
    }
    
    fileprivate func getSuggestionValues() {
        
        /// Locations
        if appManager().arrayCountries != nil {
            suggestionValues[2] = appManager().arrayCountries
        } else {
            requestManager().getCountries(complete: { (result: [ESCountryModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayCountries = result!
                    self.suggestionValues[2] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Universities
        if appManager().arrayInstitutions != nil {
            suggestionValues[3] = appManager().arrayInstitutions
        } else {
            requestManager().getInstitutions(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayInstitutions = result!
                    self.suggestionValues[3] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Degrees
        if appManager().arrayDegrees != nil {
            suggestionValues[4] = appManager().arrayDegrees
        } else {
            requestManager().getDegrees(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayDegrees = result!
                    self.suggestionValues[4] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Majors
        if appManager().arrayMajors != nil{
            suggestionValues[5] = appManager().arrayMajors
        } else {
            requestManager().getMajors(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayMajors = result!
                    self.suggestionValues[5] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Scholarship programs
        if appManager().arrayScholarshipPrograms != nil {
            suggestionValues[6] = appManager().arrayScholarshipPrograms
        } else {
            requestManager().getScholarshipPrograms( complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayScholarshipPrograms = result!
                    self.suggestionValues[6] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - UITableView datasource   delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.btnEditAvatar.isHidden = !isEditingProfile
        if appManager().currentUser!.type == .donor {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 5
        }
//        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            if isEditingProfile {
                return 240
            } else {
                return 140
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let lblFilterTitle = ESLabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
            lblFilterTitle.text = "Select filters that apply to campaigns you would like to see"
            lblFilterTitle.font = UIFont(name: ESConstant.FontName.Bold, size: 14)
            lblFilterTitle.textColor = ESConstant.Color.GrayFontColor
            lblFilterTitle.textAlignment = .center
            lblFilterTitle.numberOfLines = 0
            lblFilterTitle.backgroundColor = ESConstant.Color.ViewBackground
            
            return lblFilterTitle
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section == 0 ? indexPath.row : indexPath.row + 2
        let field = fields[index]
        let type = field[fieldType] as! Int
        let value = tempararyValues[index]

        /// TextField cell
        if type == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField0CellIdentifier) as! ESStudentProfileField0Cell
            cell.lblTitle.text = field[fieldTitle] as? String
            
            cell.textField.isEnabled = isEditingProfile
            
//            var value: String? = tempararyValues[index]
            /*if isEditingProfile == true, let tempValue = tempararyValues[index] {
                value = tempValue
            } else {
                value = field[fieldText] as? String
            } */
            cell.textField.text = value
//            cell.textField.delegate = cell
            cell.delegate = self
            return cell
            
        }
            
            /// TextField & Options cell
        else if type == 20 {
            var cell: ESStudentProfileField1Cell!
            cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField1CellIdentifier) as! ESStudentProfileField1Cell

            
            cell.setEditable(isEditingProfile)
            
            cell.lblTitle.text = field[fieldTitle] as? String
            
//            var value: String?
            if isEditingProfile {
                /*
                if let tempValue = tempararyValues[index] {
                    value = tempValue
                } */
                
                cell.setDatasource(suggestionValues[index] ?? [],
                                   selectedValues: tempararySelectedOptions[index] ?? [],
                                   textFieldValue: value)
                
            } else {
                cell.setDatasource(suggestionValues[index] ?? [],
                                   selectedValues: field[fieldText] as? [ESBaseObjectModel] ?? [],
                                   textFieldValue: nil)
            }
            
            cell.delegate = self
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - ProfileFieldCell delegate
    
    func studentProfileField(cell: ESStudentProfileFieldCell, changedText: String?) {
        if let indexPath = tableView.indexPath(for: cell) {
            let index = indexPath.section == 0 ? indexPath.row : indexPath.row + 2
            tempararyValues[index] = changedText
            self.isEditedProfile = true
        }
    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValue: ESBaseObjectModel?) {

    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValues: [ESBaseObjectModel]) {
        if let indexPath = tableView.indexPath(for: cell) {
            let index = indexPath.section == 0 ? indexPath.row : indexPath.row + 2
            tempararySelectedOptions[index] = selectedValues
            self.isEditedProfile = true
        }
    }
    
    func studentProfileFieldShouldBeginEditing(cell: ESStudentProfileField1Cell) {
        /*
        if let indexPath = tableView.indexPath(for: cell) {
            
            var prevIndex: Int = -1
            for key in editingCell.keys {
                if editingCell[key]! == true {
                    prevIndex = key
                }
                editingCell[key] = false
            }
            editingCell[indexPath.row] = true
            var cells: [IndexPath] = [indexPath]
            if prevIndex >= 0 {
                let prevIndexPath = IndexPath(row: prevIndex, section: indexPath.section)
                cells.append(prevIndexPath)
            }
            self.tableView.reloadRows(at: cells, with: .fade)
        } */
    }
    
    func studentProfileFieldShouldEndEditing(cell: ESStudentProfileField1Cell) {
        if let indexPath = tableView.indexPath(for: cell) {
            editingCell[indexPath.row] = false
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Override 
    
    override func parametersToSave() -> [String : Any] {
        var params: [String: Any] = [:]
        for index in 0...(fields.count - 1) {
            let paramName = fields[index][parameterName] as! String
            params[paramName] = ""
            if 2 <= index && index <= 6  {
                if let optionValue = tempararySelectedOptions[index],
                    let joinedIds = joinedIds(ofArray: optionValue) {
                    params[paramName] = joinedIds
                }
            } else { //if index == 3 {
                if let value = tempararyValues[index] {
                    params[paramName] = value
                }
            }
        }
        return params
    }
    
    override func resetTempararyValues() {
        for index in 0...(self.tempararyValues.count - 1) {
            tempararyValues[index] = nil
            tempararySelectedOptions[index] = []
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
