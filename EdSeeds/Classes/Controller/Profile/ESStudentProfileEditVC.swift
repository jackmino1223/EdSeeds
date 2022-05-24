//
//  ESStudentProfileEditVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/22/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DatePickerDialog

class ESStudentProfileEditVC: ESStudentProfileBaseVC,
        ESStudentProfileField1CellDelegate,
        ESStudentProfileFieldGenderCellDelegate,
        ESStudentProfileFieldBirthdayCellDelegate,
        ESStudentProfileFieldScholarshipCellDelegate {
    
    var fields: [[String: Any]] = [
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
        [ // 2
            fieldTitle : "Student ID",
            fieldType : 10,
            parameterName : "student_id",
            ],
        [ // 3
            fieldTitle : "Gender",
            fieldType : 40,
            parameterName : "gender",
            ],
        [ // 4
            fieldTitle : "Birth Date",
            fieldType : 50,
            parameterName : "birth_of_date",
            ],
        [ // 5
            fieldTitle : "Location",
            fieldType : 20,
            parameterName : "location",
            ],
        [ // 6
            fieldTitle : "University",
            fieldType : 20,
            parameterName : "university",
            ],
        [ // 7
            fieldTitle : "Degree",
            fieldType : 20,
            parameterName : "degree",
            ],
        [ // 8
            fieldTitle : "Major",
            fieldType : 20,
            parameterName : "major",
            ],
        [ // 9
            fieldTitle : "Scholarship Program",
            fieldType : 21,
            parameterName : "scholarship_prg",
            ],
        [ // 10
            fieldTitle : "Dream and Mission Statement:",
            fieldType : 30,
            parameterName : "statement",
            fieldPlaceholder : "Let donors know what you hopoe to achieve in your life.",
            ],
        [ // 11
            fieldTitle : "Why donors should fund you?",
            fieldType : 30,
            parameterName : "why_fund",
            fieldPlaceholder : "What makes you special? Continuing your education will enable you to?",
            ],
        [ // 12
            fieldTitle : "How you've given back",
            fieldType : 30,
            parameterName : "howgiveback",
            fieldPlaceholder : "Your volunteer experience",
            ],
        [ // 13
            fieldTitle : "Your blog",
            fieldType : 10,
            parameterName : "yourblog",
            fieldPlaceholder : "Where you share your opinions and thought ",
            ],
        [ // 14
            fieldTitle : "Your portfolio",
            fieldType : 10,
            parameterName : "portfolio",
            fieldPlaceholder : "Sample of your work.",
            ],
        [ // 15
            fieldTitle : "Other bragging rights",
            fieldType : 10,
            parameterName : "other_rights",
            fieldPlaceholder : "Awards and other achievements your are proud of.",
            ],
        
    ]
    
    fileprivate var tempararyValues: [Any?] = Array(repeating: nil, count: 16)
    fileprivate var tempararySelectedOptions: [ESBaseObjectModel?] = Array(repeating: nil, count: 16)
    fileprivate var tempararyScholarshipCode: String?
    
    fileprivate var suggestionValues: [Int: [ESBaseObjectModel]] = [:]
//    fileprivate var editingCell: [Int: Bool] = [:]

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        imgviewAvatar.makeCircle()
        
        getUserInformation()
        getSuggestionValues()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Profile"
    }
        
    override func getUserInformation() {
        let currentUser = appManager().currentUser!
        
        fields[0][fieldText] = currentUser.firstName
        fields[1][fieldText] = currentUser.lastName
        
        /*if let studentId = currentUser.studentId {
            fields[2][fieldText] = studentId
        }
        if currentUser.gender.characters.count > 0 {
            fields[3][fieldText] = currentUser.gender
        }
        if let birthday = currentUser.birthOfDate {
            fields[4][fieldText] = birthday
        } */
        if currentUser.locations.count > 0 {
            fields[5][fieldText] = currentUser.locations[0]
            tempararySelectedOptions[5] = currentUser.locations[0]
        }
        if currentUser.universities.count > 0 {
            fields[6][fieldText] = currentUser.universities[0]
            tempararySelectedOptions[6] = currentUser.universities[0]
        }
        if currentUser.degrees.count > 0 {
            fields[7][fieldText] = currentUser.degrees[0]
            tempararySelectedOptions[7] = currentUser.degrees[0]
        }
        if currentUser.majors.count > 0 {
            fields[8][fieldText] = currentUser.majors[0]
            tempararySelectedOptions[8] = currentUser.majors[0]
        }
        if currentUser.scholarshipPrograms.count > 0 {
            fields[9][fieldText] = currentUser.scholarshipPrograms[0]
            tempararySelectedOptions[9] = currentUser.scholarshipPrograms[0]
        }
        /*
        if let statement = currentUser.statement {
            fields[10][fieldText] = statement
        }
        if let whyfund = currentUser.whyFund {
            fields[11][fieldText] = whyfund
        }
        if let givenBack = currentUser.howGiveBack {
            fields[12][fieldText] = givenBack
        }
        if let blog = currentUser.yourBlog {
            fields[13][fieldText] = blog
        }
        
//        fields[14][fieldText] = currentUser.firstName
        
        if let otherRights = currentUser.otherRights {
            fields[14][fieldText] = otherRights
        } */
        
        tempararyValues[0] = currentUser.firstName
        tempararyValues[1] = currentUser.lastName
        tempararyValues[2] = currentUser.studentId
        tempararyValues[3] = currentUser.gender
        tempararyValues[4] = currentUser.birthOfDate
        tempararyValues[5] = nil
        tempararyValues[6] = nil
        tempararyValues[7] = nil
        tempararyValues[8] = nil
        tempararyValues[9] = nil
        tempararyValues[10] = currentUser.statement
        tempararyValues[11] = currentUser.whyFund
        tempararyValues[12] = currentUser.howGiveBack
        tempararyValues[13] = currentUser.yourBlog
        tempararyValues[14] = nil
        tempararyValues[15] = currentUser.otherRights
        
    }
    
    
    fileprivate func getSuggestionValues() {
        
        /// Locations
        if appManager().arrayCountries != nil {
            suggestionValues[5] = appManager().arrayCountries
        } else {
            requestManager().getCountries(complete: { (result: [ESCountryModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayCountries = result!
                    self.suggestionValues[5] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Universities
        if appManager().arrayInstitutions != nil {
            suggestionValues[6] = appManager().arrayInstitutions
        } else {
            requestManager().getInstitutions(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayInstitutions = result!
                    self.suggestionValues[6] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Degrees
        if appManager().arrayDegrees != nil {
            suggestionValues[7] = appManager().arrayDegrees
        } else {
            requestManager().getDegrees(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayDegrees = result!
                    self.suggestionValues[7] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Majors
        if appManager().arrayMajors != nil{
            suggestionValues[8] = appManager().arrayMajors
        } else {
            requestManager().getMajors(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayMajors = result!
                    self.suggestionValues[8] = result!
                    if self.isEditingProfile {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        /// Scholarship programs
        if appManager().arrayScholarshipPrograms != nil {
            suggestionValues[9] = appManager().arrayScholarshipPrograms
        } else {
            requestManager().getScholarshipPrograms( complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayScholarshipPrograms = result!
                    self.suggestionValues[9] = result!
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let field = fields[indexPath.row]
        let type = field[fieldType] as! Int
        if type == 30 {
            return 130
        } else {
            if (type == 20 || type == 21) {
                
                if isEditingProfile {
                    return 240
                } else {
                    return 140
                }
                
            } else {
                
                return 90
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = fields[indexPath.row]
        let type = field[fieldType] as! Int
        let value = tempararyValues[indexPath.row] as? String
        
        /// TextField cell
        if type == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField0CellIdentifier) as! ESStudentProfileField0Cell
            cell.lblTitle.text = field[fieldTitle] as? String
            
            cell.textField.isEnabled = isEditingProfile
            cell.textField.placeholder = field[fieldPlaceholder] as? String
            
            /*
            var value: String?
            if isEditingProfile == true, let tempValue = tempararyValues[indexPath.row] {
                value = tempValue as? String
            } else {
                value = field[fieldText] as? String
            } */
            
            cell.textField.text = value
            cell.delegate = self
            return cell
            
        }
        
        /// TextField & Options cell
        else if type == 20 || type == 21 {
            var cell: ESStudentProfileField1Cell!
            if type == 20 {
                cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField1CellIdentifier) as! ESStudentProfileField1Cell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileFieldScholarshipCellIdentifier) as! ESStudentProfileFieldScholarshipCell
            }
            
            cell.setEditable(isEditingProfile)
            
            cell.lblTitle.text = field[fieldTitle] as? String
            
//            var value: String? = nil
            if isEditingProfile == true {
                /*
                if let tempValue = tempararyValues[indexPath.row] {
                    value = tempValue as? String
                } */
                cell.setDatasource(suggestionValues[indexPath.row] ?? [],
                                   selectedValue: tempararySelectedOptions[indexPath.row],
                                   textFieldValue: value)

            } else {

                let selectedValue: ESBaseObjectModel? = field[fieldText] as? ESBaseObjectModel

                cell.setDatasource(suggestionValues[indexPath.row] ?? [],
                                   selectedValue: selectedValue,
                                   textFieldValue: nil)

            }

            cell.delegate = self
            cell.indexPath = indexPath
            if type == 21 {
                let scholarCell = cell as! ESStudentProfileFieldScholarshipCell
                if isEditingProfile == true {
                    scholarCell.txtScholarshipCode.text = tempararyScholarshipCode
                } else {
                    scholarCell.txtScholarshipCode.text = appManager().currentUser!.scholarshipCode
                }
                scholarCell.txtScholarshipCode.delegate = cell
                
            }
            
            return cell
        }
            
        /// TextView cell
        else if type == 30 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField2CellIdentifier) as! ESStudentProfileField2Cell
            cell.lblTitle.text = field[fieldTitle] as? String
            cell.textView.isEditable = isEditingProfile
            cell.textView.placeholder = (field[fieldPlaceholder] as? String) ?? ""
            /*
            var value: String?
            if isEditingProfile == true, let tempValue = tempararyValues[indexPath.row] {
                value = tempValue as? String
            } else {
                value = field[fieldText] as? String
            } */
            cell.textView.text = value
            cell.delegate = self
            return cell
        }
        
        /// Gender Cell
        else if type == 40 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileFieldGenderCellIdentifier) as! ESStudentProfileFieldGenderCell
            
            cell.btnMale.isEnabled = isEditingProfile
            cell.btnFemale.isEnabled = isEditingProfile
            
            /*
            var value: Bool?
            if isEditingProfile == true, let tempValue = tempararyValues[indexPath.row] {
                value = tempValue as? Bool
            } else {
                if appManager().currentUser!.gender.lowercased() == "m" {
                    value = true
                } else if appManager().currentUser!.gender.lowercased() == "f" {
                    value = false
                }
            } */
            
            cell.selectMale(value)
            
            cell.delegate = self
            return cell
        }
        
        /// Calendar Cell
        else if type == 50 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileFieldBirthdayCellIdentifier) as! ESStudentProfileFieldBirthdayCell
            
            cell.lblTitle.text = field[fieldTitle] as? String
            cell.textField.isEnabled = isEditingProfile
            
            /*
            var value: String?
            if isEditingProfile == true, let tempValue = tempararyValues[indexPath.row] {
                value = tempValue as? String
            } else {
                value = field[fieldText] as? String
            } */
            cell.textField.text = value
//            cell.textField.delegate = cell
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - ProfileFieldCell delegate
    func studentProfileField(cell: ESStudentProfileFieldGenderCell, isMale: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            tempararyValues[indexPath.row] = isMale ? "m" : "f"
            self.isEditedProfile = true
        }
    }
    
    func studentProfileField(cell: ESStudentProfileFieldCell, changedText: String?) {
        if let indexPath = tableView.indexPath(for: cell) {
            tempararyValues[indexPath.row] = changedText
            self.isEditedProfile = true
        }
    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValue: ESBaseObjectModel?) {
        if let indexPath = tableView.indexPath(for: cell) {
            tempararySelectedOptions[indexPath.row] = selectedValue
            self.isEditedProfile = true
        }
    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValues: [ESBaseObjectModel]) {

    }

    func studentProfileField(cellBirthdaySelecting cell: ESStudentProfileFieldBirthdayCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            DatePickerDialog().show(title: NSLocalizedString("Select Date", comment: ""),
                                    doneButtonTitle: NSLocalizedString("Select", comment: ""),
                                    cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                                    datePickerMode: .date) { (date) -> Void in
                                        if date != nil {
                                            if date! > Date() {
                                                self.showSimpleAlert(title: "Warning", message: "Date of Birth cannot be in the future.", dismissed: nil)
                                            } else {
                                                let birthday = ESConstant.ESDateFormatter.OnlyDate.string(from: date!)
                                                cell.textField.text = birthday
                                                self.tempararyValues[indexPath.row] = birthday
                                                self.isEditedProfile = true
                                            }
                                        }
            }
        }
    }
    
    func studentProfileField(cell: ESStudentProfileFieldCell, changedScholarshipCode: String?) {
        tempararyScholarshipCode = changedScholarshipCode
        self.isEditedProfile = true
    }
    
    func studentProfileFieldShouldBeginEditing(cell: ESStudentProfileField1Cell) {
        /*
        if let indexPath = tableView.indexPath(for: cell) {
//            self.tableView.beginUpdates()
            var prevIndex: Int = -1
            for key in editingCell.keys {
                if editingCell[key]! == true && key != indexPath.row {
                    prevIndex = key
                }
                editingCell[key] = false
            }
            editingCell[indexPath.row] = true
//            self.tableView.endUpdates()
            
            
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
//            editingCell[indexPath.row] = false
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Override
    
    override func parametersToSave() -> [String : Any] {
        var params: [String: Any] = [:]
        for index in 0...(fields.count - 1) {
            let paramName = fields[index][parameterName] as! String
            params[paramName] = ""
            if 5 <= index && index <= 9  {
                if let optionValue = tempararySelectedOptions[index] {
                    params[paramName] = optionValue.id
                }
            }/* else if index == 3 {
                if let value = tempararyValues[index] as? Bool {
                    params[paramName] = value ? "M" : "F"
                }
            }*/ else { //if index == 3 {
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
//            tempararySelectedOptions[index] = nil
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
