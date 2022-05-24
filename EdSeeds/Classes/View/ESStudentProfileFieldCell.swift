//
//  ESStudentProfileField1Cell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/26/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import TagListView
import KMPlaceholderTextView

let ESStudentProfileField0CellIdentifier            = "ESStudentProfileField0Cell"
let ESStudentProfileField1CellIdentifier            = "ESStudentProfileField1Cell"
let ESStudentProfileField2CellIdentifier            = "ESStudentProfileField2Cell"
let ESStudentProfileFieldGenderCellIdentifier       = "ESStudentProfileFieldGenderCell"
let ESStudentProfileFieldBirthdayCellIdentifier     = "ESStudentProfileFieldBirthdayCell"
let ESStudentProfileFieldScholarshipCellIdentifier  = "ESStudentProfileFieldScholarshipCell"

class ESStudentProfileFieldCell: ESTableViewCell {
    var delegate: ESStudentProfileFieldCellDelegate?
}

protocol ESStudentProfileFieldCellDelegate {
    func studentProfileField(cell: ESStudentProfileFieldCell, changedText: String?) -> Void
}

/*********************************************
 CLASS   :   ESStudentProfileField0Cell
 **********************************************/
class ESStudentProfileField0Cell: ESStudentProfileFieldCell, UITextFieldDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = ESConstant.Color.BorderColor
        textField.makeBorder(width: 1, color: borderColor)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangedText(_:)), for: .editingChanged)

    }

    // MARK: - UITextField delegate
    func textFieldDidChangedText(_ textfield: UITextField) -> Void {
        delegate?.studentProfileField(cell: self, changedText: textField.text)
    }
    
}

/*********************************************
 CLASS   :   ESStudentProfileFieldBirthdayCell
 **********************************************/
class ESStudentProfileFieldBirthdayCell: ESStudentProfileField0Cell {
    @IBOutlet weak var imgviewIcon: UIImageView?

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileFieldBirthdayCellDelegate {
                selfDelegate.studentProfileField(cellBirthdaySelecting: self)
                return false
            }
        }
        return true
    }
}

protocol ESStudentProfileFieldBirthdayCellDelegate: ESStudentProfileFieldCellDelegate {
    func studentProfileField(cellBirthdaySelecting cell: ESStudentProfileFieldBirthdayCell) -> Void
}

/*********************************************
 CLASS   :   ESStudentProfileField1Cell
 **********************************************/
class ESStudentProfileField1Cell: ESStudentProfileField0Cell,
            UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
            TagListViewDelegate {

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var clsviewOptions: UICollectionView!
    
    @IBOutlet weak var tagviewValues: TagListView!
    @IBOutlet weak var tagviewSearchResult: TagListView!
    @IBOutlet weak var scrviewTagValues: UIScrollView!
    @IBOutlet weak var scrviewTagSearchResult: UIScrollView!
    @IBOutlet weak var constraintTagValueHeight: NSLayoutConstraint!
    
    fileprivate var isEditable: Bool = false
    
    fileprivate var dataSource: [ESBaseObjectModel]  = []
    fileprivate var selectedValue: ESBaseObjectModel?
    fileprivate var queryResult: [ESBaseObjectModel] = []
    
    fileprivate var isMultipleSelecting: Bool = false
    fileprivate var selectedValues: [ESBaseObjectModel] = []
    
    // MARK:
    override func awakeFromNib() {
        super.awakeFromNib()
//        clsviewOptions.backgroundColor = ESConstant.Color.ViewBackground
        
        let font = UIFont(name: ESConstant.FontName.Bold, size: 14)!
        
        tagviewValues.textFont = font
        tagviewSearchResult.textFont = font
        
        tagviewValues.delegate = self
        tagviewSearchResult.delegate = self
        
        let borderColor = ESConstant.Color.BorderColor
        scrviewTagValues.makeBorder(width: 1, color: borderColor)
        scrviewTagValues.backgroundColor = UIColor.white
        scrviewTagSearchResult.backgroundColor = UIColor.clear
        
        textField.delegate = self
    }
    
    func setEditable(_ editable: Bool) -> Void {
        isEditable = editable
        textField.isEnabled = editable
//        clsviewOptions.isHidden = !editable
//        clsviewOptions.dataSource = self
//        clsviewOptions.delegate = self
        tagviewSearchResult.isHidden = !editable
        tagviewValues.isUserInteractionEnabled = editable
    }
    
    func setDatasource(_ ds: [ESBaseObjectModel], selectedValue sv: ESBaseObjectModel?, textFieldValue: String?) -> Void {
        isMultipleSelecting = false
        dataSource = ds
        selectedValue = sv
//        textFieldDidChangedText(textField)
        textField.text = textFieldValue
        changedSearchText(textFieldValue)
        self.constraintTagValueHeight.constant = 38
        updateConstraints()
    }
    
    func setDatasource(_ ds: [ESBaseObjectModel], selectedValues sv: [ESBaseObjectModel], textFieldValue: String?) -> Void {
        isMultipleSelecting = true
        dataSource = ds
        selectedValues = sv
        textField.text = textFieldValue
        changedSearchText(textFieldValue)
        self.constraintTagValueHeight.constant = 65
        updateConstraints()
    }

    // MARK: - UITextField delegate
    override func textFieldDidChangedText(_ textfield: UITextField) -> Void {
        
        changedSearchText(textField.text!)
        super.textFieldDidChangedText(textfield)
    }
    
    fileprivate func changedSearchText(_ text: String?) {
        if let queryText = text, queryText.characters.count > 0 {
            queryResult.removeAll()
            for value in dataSource {
                if value.enName.lowercased().range(of: queryText.lowercased()) != nil {
                    queryResult.append(value)
                }
            }
        } else {
            queryResult = dataSource
        }

        reloadTags()

    }
    
    fileprivate func reloadTags() {
        tagviewSearchResult.removeAllTags()
        tagviewValues.removeAllTags()
        
        if isMultipleSelecting {
            for object0 in queryResult {
                var exist = false
                for object1 in selectedValues {
                    if object0.id == object1.id {
                        exist = true
                        break
                    }
                }
                if exist == false {
                    //                tagNames.append(object0.enName)
                    tagviewSearchResult.addTag(object0.enName)
                }
            }
            
            for object1 in selectedValues {
                tagviewValues.addTag(object1.enName)
            }
        } else {
            for object0 in queryResult {
                if let sv = selectedValue, object0.id == sv.id {
//                    tagviewValues.addTag(sv.enName)
                } else {
                    tagviewSearchResult.addTag(object0.enName)
                }
            }
            if selectedValue != nil {
                tagviewValues.addTag(selectedValue!.enName)
            }
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
            selfDelegate.studentProfileFieldShouldBeginEditing(cell: self)
        }
        return true
    }
    
    /*
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
//            selfDelegate.studentProfileFieldShouldEndEditing(cell: self)
        }
        return true
    } */
    
    // MARK: - TagListView delegate
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == tagviewSearchResult {
            
            for object0 in queryResult {
                if object0.enName == title {
                    if isMultipleSelecting {
                        selectedValues.append(object0)
                    } else {
                        if selectedValue != nil {
                            queryResult.append(selectedValue!)
                        }
                        selectedValue = object0
                    }
                    queryResult.remove(at: queryResult.index(of: object0)!)
                    break
                }
            }
            reloadTags()
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
                if isMultipleSelecting {
                    selfDelegate.studentProfileField(cell: self, selectedValues: selectedValues)
                } else {
                    selfDelegate.studentProfileField(cell: self, selectedValue: selectedValue)
                }
            }

        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == tagviewValues {
            if isMultipleSelecting {
                for object0 in selectedValues {
                    if object0.enName == title {
                        selectedValues.remove(at: selectedValues.index(of: object0)!)
                        break
                    }
                }
            } else {
                selectedValue = nil
            }
            textFieldDidChangedText(textField)
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
                if isMultipleSelecting {
                    selfDelegate.studentProfileField(cell: self, selectedValues: selectedValues)
                } else {
                    selfDelegate.studentProfileField(cell: self, selectedValue: selectedValue)
                }
            }

        }
    }
    
    
    // MARK: - UICollectionView datasource, delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queryResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ESSuggestionValueCellIdentifier, for: indexPath) as! ESSuggestionValueCell
        
        let value = queryResult[indexPath.row]

        cell.lblTitle.text = value.enName
        if isMultipleSelecting {
            
            var exist: Bool = false
            for elem in selectedValues {
                if value.id == elem.id {
                    exist = true
                    break
                }
            }
            cell.check = exist
            
        } else {
            if selectedValue != nil, selectedValue!.id == value.id {
                cell.check = true
            } else {
                cell.check = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.5 - 2
        let cellSize = CGSize(width: width, height: 30)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let clickedValue = queryResult[indexPath.row]
        if isMultipleSelecting {
            var matchIndex: Int?
            var index: Int = 0
            for value in selectedValues {
                if value.id == clickedValue.id {
                    matchIndex = index
                    break
                }
                index += 1
            }
            if matchIndex != nil {
                selectedValues.remove(at: matchIndex!)
            } else {
                selectedValues.append(clickedValue)
            }
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
                selfDelegate.studentProfileField(cell: self, selectedValues: selectedValues)
            }

        } else {
            if selectedValue != nil, selectedValue!.id == clickedValue.id {
                selectedValue = nil
            } else {
                selectedValue = clickedValue
            }
            
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileField1CellDelegate {
                selfDelegate.studentProfileField(cell: self, selectedValue: selectedValue)
            }
        }
        collectionView.reloadData()
    }
    
}

protocol ESStudentProfileField1CellDelegate: ESStudentProfileFieldCellDelegate {
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValue: ESBaseObjectModel?) -> Void
    func studentProfileField(cell: ESStudentProfileField1Cell, selectedValues: [ESBaseObjectModel]) -> Void
    func studentProfileFieldShouldBeginEditing(cell: ESStudentProfileField1Cell) -> Void
//    func studentProfileFieldShouldEndEditing(cell: ESStudentProfileField1Cell) -> Void
}


/*********************************************
 CLASS   :   ESStudentProfileFieldScholarshipCell
 **********************************************/
class ESStudentProfileFieldScholarshipCell: ESStudentProfileField1Cell {
    
    @IBOutlet weak var txtScholarshipCode: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = ESConstant.Color.BorderColor
        txtScholarshipCode.makeBorder(width: 1, color: borderColor)
        txtScholarshipCode.delegate = self
        txtScholarshipCode.addTarget(self, action: #selector(textFieldDidChangedText(_:)), for: .editingChanged)
        
    }

    override func textFieldDidChangedText(_ textfield: UITextField) {
        if textfield == txtScholarshipCode {
            if delegate != nil, let selfDelegate = delegate! as? ESStudentProfileFieldScholarshipCellDelegate {
                selfDelegate.studentProfileField(cell: self, changedScholarshipCode: txtScholarshipCode.text)
            }
        } else {
            super.textFieldDidChangedText(textfield)
        }
    }
    
}

protocol ESStudentProfileFieldScholarshipCellDelegate: ESStudentProfileField1CellDelegate {
    func studentProfileField(cell: ESStudentProfileFieldCell, changedScholarshipCode: String?) -> Void
}

/*********************************************
 CLASS   :   ESStudentProfileField2Cell
 **********************************************/
class ESStudentProfileField2Cell: ESStudentProfileFieldCell, UITextViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = ESConstant.Color.BorderColor
        textView.makeBorder(width: 1, color: borderColor)
        
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.studentProfileField(cell: self, changedText: textView.text)
    }
}

/*********************************************
 CLASS   :   ESStudentProfileFieldGenderCell
 **********************************************/
class ESStudentProfileFieldGenderCell: ESTableViewCell {
    
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var delegate: ESStudentProfileFieldGenderCellDelegate?
    
    @IBAction func onPressGender(_ sender: Any) {
        if sender as! UIButton == btnMale {
            self.btnMale.setBackgroundImage(UIImage(named: "iconMaleSelected"), for: .normal)
            self.btnFemale.setBackgroundImage(UIImage(named: "iconFemaleUnselected"), for: .normal)
            delegate?.studentProfileField(cell: self, isMale: true)
        } else {
            self.btnMale.setBackgroundImage(UIImage(named: "iconMaleUnselected"), for: .normal)
            self.btnFemale.setBackgroundImage(UIImage(named: "iconFemaleSelected"), for: .normal)
            delegate?.studentProfileField(cell: self, isMale: false)
        }
    }
    
    func selectMale(_ value: String?) -> Void {
        
        self.btnMale.setBackgroundImage(UIImage(named: "iconMaleUnselected"), for: .normal)
        self.btnFemale.setBackgroundImage(UIImage(named: "iconFemaleUnselected"), for: .normal)

        if value != nil {
            if value!.lowercased() == "m" {
                self.btnMale.setBackgroundImage(UIImage(named: "iconMaleSelected"), for: .normal)
            } else if value!.lowercased() == "f" {
                self.btnFemale.setBackgroundImage(UIImage(named: "iconFemaleSelected"), for: .normal)
            }
        }

    }
    
}

protocol ESStudentProfileFieldGenderCellDelegate {
    func studentProfileField(cell: ESStudentProfileFieldGenderCell, isMale: Bool) -> Void
}
