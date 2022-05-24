//
//  ESJoinAsStudentCompleteVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/20/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

class ESJoinAsStudentCompleteVC: ESBaseScrollViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtLocation: ESTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var txtUniversity: ESTextField!
    @IBOutlet weak var txtDegree: ESTextField!
    @IBOutlet weak var txtMajor: ESTextField!
    @IBOutlet weak var txtScholarshipCode: ESTextField!
    @IBOutlet weak var txtScholarshipTitle: ESTextField!
    @IBOutlet weak var tblLocationList: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var constraintTopSpaceForSuggestionList: NSLayoutConstraint!
    
    fileprivate var arraySuggestionDatas: [[String]] = Array(repeating: [], count: 5) 
    fileprivate var arrayLocations: [ESCountryModel] = []
    fileprivate var arrayUniversities: [ESBaseObjectModel] = []
    fileprivate var arrayDegrees: [ESBaseObjectModel] = []
    fileprivate var arrayMajors: [ESBaseObjectModel] = []
    fileprivate var arrayScholarship: [ESBaseObjectModel] = []
    
    fileprivate var selectedTextFieldIndex: Int = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        txtLocation.makeBorder(width: 1, color: borderColor)
        btnSearch.makeBorder(width: 1, color: borderColor)
        txtUniversity.makeBorder(width: 1, color: borderColor)
        txtDegree.makeBorder(width: 1, color: borderColor)
        txtMajor.makeBorder(width: 1, color: borderColor)
        txtScholarshipCode.makeBorder(width: 1, color: borderColor)
        txtScholarshipTitle.makeBorder(width: 1, color: borderColor)
        
        btnNext.makeRound()
        
        loadSuggestionDatas()
        
        txtLocation.tag = 100
        txtUniversity.tag = 101
        txtDegree.tag  = 102
        txtMajor.tag = 103
        txtScholarshipTitle.tag = 104
        
        /*
        txtLocation.onSelect = { text, indexpath in
            
        }
        
        txtUniversity.onSelect = { text, indexpath in
            
        }
        
        txtDegree.onSelect = { text, indexpath in
            
        }
        
        txtMajor.onSelect = { text, indexpath in
            
        }
        
        txtScholarshipTitle.onSelect = { text, indexpath in
            
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = tblLocationList.frame.height
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
//        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "JOIN AS STUDENT"
    }
    
    fileprivate func batchSetOptionsFor(textfield: ESAutoCompleteTextField) {
        textfield.hidesWhenEmpty = false
        
    }
    
    fileprivate func loadSuggestionDatas() {

        requestManager().getCountries { (countryResult: [ESCountryModel]?, countryError: String?) in
            if countryResult != nil {
                var countries: [String] = []
                for country in countryResult! {
                    countries.append(country.enName)
                }
//                self.txtLocation.autoCompleteStrings = countries
                self.reloadSuggestionTableView(index: 0, data: countries)
                self.arrayLocations.append(contentsOf: countryResult!)
            }
            
            
            self.requestManager().getInstitutions(complete: { (instResult: [ESBaseObjectModel]?, instError: String?) in
                if instResult != nil {
                    var universities: [String] = []
                    for inst in instResult! {
                        universities.append(inst.enName)
                    }
//                    self.txtUniversity.autoCompleteStrings = universities
                    self.reloadSuggestionTableView(index: 1, data: universities)
                    self.arrayUniversities.append(contentsOf: instResult!)
                }
                
                
                self.requestManager().getDegrees(complete: { (degreeResult: [ESBaseObjectModel]?, degreeError: String?) in
                    if degreeResult != nil {
                        var degrees: [String] = []
                        for degree in degreeResult! {
                            degrees.append(degree.enName)
                        }
//                        self.txtDegree.autoCompleteStrings = degrees
                        self.reloadSuggestionTableView(index: 2, data: degrees)
                        self.arrayDegrees.append(contentsOf: degreeResult!)
                    }
                    
                    
                    self.requestManager().getMajors(complete: { (majorResult: [ESBaseObjectModel]?, majorError: String?) in
                        if majorResult != nil {
                            var majors: [String] = []
                            for major in majorResult! {
                                majors.append(major.enName)
                            }
//                            self.txtMajor.autoCompleteStrings = majors
                            self.reloadSuggestionTableView(index: 3, data: majors)
                            self.arrayMajors.append(contentsOf: majorResult!)
                        }
                        
                        
                        self.requestManager().getScholarshipPrograms(complete: { (scholarshipResult: [ESBaseObjectModel]?, scholarshipError: String?) in
                            if scholarshipResult != nil {
                                var scholarshipPrograms: [String] = []
                                for scholarship in scholarshipResult! {
                                    scholarshipPrograms.append(scholarship.enName)
                                }
//                                self.txtScholarshipTitle.autoCompleteStrings = scholarshipPrograms
                                self.reloadSuggestionTableView(index: 4, data: scholarshipPrograms)
                                self.arrayScholarship.append(contentsOf: scholarshipResult!)
                            }
                        })
                    })
                })
            })
        }
    }
    
    fileprivate func reloadSuggestionTableView(index: Int, data: [String]) {
        self.arraySuggestionDatas[index].append(contentsOf: data)
        if selectedTextFieldIndex == index {
            self.tblLocationList.reloadData()
        }
    }
    
    fileprivate func arraySelecting() -> [String] {
        if 0 <= selectedTextFieldIndex && selectedTextFieldIndex < arraySuggestionDatas.count  {
            return arraySuggestionDatas[selectedTextFieldIndex]
        } else {
            return []
        }
    }
    
    fileprivate func selectSuggestionValue(index: Int) {
        if let textfield = activeTextField() {
            textfield.text = arraySelecting()[index]
            tblLocationList.isHidden = true
        }
    }
    
    fileprivate func activeTextField() -> ESTextField? {
        var textField: ESTextField?
        switch selectedTextFieldIndex {
        case 0:
            textField = txtLocation
            break
        case 1:
            textField = txtUniversity
            break
        case 2:
            textField = txtDegree
            break
        case 3:
            textField = txtMajor
            break
        case 4:
            textField = txtScholarshipTitle
            break
        default:
            
            break
        }
        return textField
    }
    
    override func keyboardWillHideRect() {
        tblLocationList.isHidden = true
    }
    
    // MARK: - UITextField delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextFieldIndex = textField.tag - 100
        if 0 <= selectedTextFieldIndex && selectedTextFieldIndex < arraySuggestionDatas.count {
            
            tblLocationList.isHidden = false
            tblLocationList.reloadData()
            
            constraintTopSpaceForSuggestionList.constant = textField.superview!.frame.maxY
            updateConstraintWithAnimate(false)
            
        } else {
            tblLocationList.isHidden = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtLocation {
            txtUniversity.becomeFirstResponder()
        } else if textField == txtUniversity {
            txtDegree.becomeFirstResponder()
        } else if textField == txtDegree {
            txtMajor.becomeFirstResponder()
        } else if textField == txtMajor {
            txtScholarshipTitle.becomeFirstResponder()
        } else if textField == txtScholarshipTitle {
            txtScholarshipCode.becomeFirstResponder()
        } else if textField == txtScholarshipCode {
            txtScholarshipCode.resignFirstResponder()
        }
        return true
    }
    
    
    // MARK: - UITableView datasource delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySelecting().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ESLocationListCellIdentifier) as! ESLocationListCell
        cell.lblLocationName.text = arraySelecting()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSuggestionValue(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Next action
    @IBAction func onPressNext(_ sender: Any) {
        let registeringUser = appManager().registeringUser
        
        if let location = txtLocation.text {
            for locationModel in arrayLocations {
                if location == locationModel.enName {
                    registeringUser!.locations = [locationModel]
                    break
                }
            }
        }
        
        if let university = txtUniversity.text {
            for universityModel in arrayUniversities {
                if university == universityModel.enName {
                    registeringUser!.universities = [universityModel]
                    break
                }
            }
        }

        if let degree = txtDegree.text {
            for degreeModel in arrayDegrees {
                if degree == degreeModel.enName {
                    registeringUser!.degrees = [degreeModel]
                    break
                }
            }
        }
        
        if let major = txtMajor.text {
            for majorModel in arrayMajors {
                if major == majorModel.enName {
                    registeringUser!.majors = [majorModel]
                    break
                }
            }
        }

        if let scholarship = txtScholarshipTitle.text {
            for scholarshipModel in arrayScholarship {
                if scholarship == scholarshipModel.enName {
                    registeringUser!.scholarshipPrograms = [scholarshipModel]
                    break
                }
            }
        }

        registeringUser!.scholarshipCode = txtScholarshipCode.text

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
