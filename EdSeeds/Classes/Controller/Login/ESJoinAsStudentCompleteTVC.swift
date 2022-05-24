//
//  ESJoinAsStudentCompleteTVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/4/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit

class ESJoinAsStudentCompleteTVC: ESTableViewController,
    ESStudentProfileField1CellDelegate,
    ESStudentProfileFieldScholarshipCellDelegate {

    var fields: [[String: Any]] = [
        [ // 0
            fieldTitle : "Location",
            fieldType : 20,
            parameterName : "location",
            ],
        [ // 1
            fieldTitle : "University",
            fieldType : 20,
            parameterName : "university",
            ],
        [ // 2
            fieldTitle : "Degree",
            fieldType : 20,
            parameterName : "degree",
            ],
        [ // 3
            fieldTitle : "Major",
            fieldType : 20,
            parameterName : "major",
            ],
        [ // 4
            fieldTitle : "Scholarship Program",
            fieldType : 21,
            parameterName : "scholarship_prg",
            ],
        ]

    fileprivate var suggestionValues: [Int: [ESBaseObjectModel]] = [:]
    fileprivate var tempararyValues: [Any?] = Array(repeating: nil, count: 16)
    fileprivate var tempararySelectedOptions: [ESBaseObjectModel?] = Array(repeating: nil, count: 16)
    fileprivate var tempararyScholarshipCode: String?
    fileprivate var editingCell: [Int: Bool] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        getSuggestionValues()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "JOIN AS STUDENT"
    }

    
    fileprivate func getSuggestionValues() {
        
        /// Locations
        if appManager().arrayCountries != nil {
            suggestionValues[0] = appManager().arrayCountries
        } else {
            requestManager().getCountries(complete: { (result: [ESCountryModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayCountries = result!
                    self.suggestionValues[0] = result!
                    self.tableView.reloadData()
                }
            })
        }
        
        /// Universities
        if appManager().arrayInstitutions != nil {
            suggestionValues[1] = appManager().arrayInstitutions
        } else {
            requestManager().getInstitutions(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayInstitutions = result!
                    self.suggestionValues[1] = result!
                    self.tableView.reloadData()
                }
            })
        }
        
        /// Degrees
        if appManager().arrayDegrees != nil {
            suggestionValues[2] = appManager().arrayDegrees
        } else {
            requestManager().getDegrees(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayDegrees = result!
                    self.suggestionValues[2] = result!
                    self.tableView.reloadData()
                }
            })
        }
        
        /// Majors
        if appManager().arrayMajors != nil{
            suggestionValues[3] = appManager().arrayMajors
        } else {
            requestManager().getMajors(complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayMajors = result!
                    self.suggestionValues[3] = result!
                    self.tableView.reloadData()
                }
            })
        }
        
        /// Scholarship programs
        if appManager().arrayScholarshipPrograms != nil {
            suggestionValues[4] = appManager().arrayScholarshipPrograms
        } else {
            requestManager().getScholarshipPrograms( complete: { (result: [ESBaseObjectModel]?, errorMessage: String?) in
                if result != nil {
                    self.appManager().arrayScholarshipPrograms = result!
                    self.suggestionValues[4] = result!
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - UITableView datasource , delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
        /*
        if let isEditingCell = editingCell[indexPath.row], isEditingCell == true {
            return 170
        } else {
            return 90
        } */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let field = fields[indexPath.row]
        let type = field[fieldType] as! Int

        if type == 20 || type == 21 {
            var cell: ESStudentProfileField1Cell!
            if type == 20 {
                cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileField1CellIdentifier) as! ESStudentProfileField1Cell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: ESStudentProfileFieldScholarshipCellIdentifier) as! ESStudentProfileFieldScholarshipCell
            }
            
            cell.setEditable(true)
            
            cell.lblTitle.text = field[fieldTitle] as? String
            
            let tempValue = tempararyValues[indexPath.row] as? String

            cell.setDatasource(suggestionValues[indexPath.row] ?? [],
                               selectedValue: tempararySelectedOptions[indexPath.row],
                               textFieldValue: tempValue)


            cell.delegate = self
            
            if type == 21 {
                let scholarCell = cell as! ESStudentProfileFieldScholarshipCell
                scholarCell.txtScholarshipCode.text = tempararyScholarshipCode
                scholarCell.txtScholarshipCode.delegate = cell
                
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: Cell delegate
    func studentProfileField(cell: ESStudentProfileFieldCell, changedText: String?) {
        if let indexPath = tableView.indexPath(for: cell) {
            tempararyValues[indexPath.row] = changedText
        }
    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValue: ESBaseObjectModel?) {
        if let indexPath = tableView.indexPath(for: cell) {
            tempararySelectedOptions[indexPath.row] = selectedValue
        }
    }
    
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValues: [ESBaseObjectModel]) {
        
    }
    
    func studentProfileField(cell: ESStudentProfileFieldCell, changedScholarshipCode: String?) {
        tempararyScholarshipCode = changedScholarshipCode
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

    // MARK: - Action
    @IBAction func onPressNext(_ sender: Any) {
        let registeringUser = appManager().registeringUser
        
        if let locationModel = tempararySelectedOptions[0] {
            registeringUser!.locations = [locationModel as! ESCountryModel]
        }
        
        if let universityModel = tempararySelectedOptions[1] {
            registeringUser!.universities = [universityModel]
        }
        
        if let degreeModel = tempararySelectedOptions[2] {
            registeringUser!.degrees = [degreeModel]
        }

        if let majorModel = tempararySelectedOptions[3] {
            registeringUser!.majors = [majorModel]
        }

        if let scholarshipModel = tempararySelectedOptions[4] {
            registeringUser!.scholarshipPrograms = [scholarshipModel]
        }
        
        registeringUser?.scholarshipCode = tempararyScholarshipCode
        
        self.performSegue(withIdentifier: ESConstant.Segue.gotoJoinAsStudentAvatarVC, sender: self)

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
