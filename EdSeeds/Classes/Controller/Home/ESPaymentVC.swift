//
//  ESPaymentVC.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/18/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import Stripe

class ESPaymentVC: ESTableViewController, UITextFieldDelegate, PayPalPaymentDelegate {

    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var progressPaid: UIProgressView!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    @IBOutlet weak var viewDonateCostBox: UIView!
    @IBOutlet weak var txtDonateCost: UITextField!
    @IBOutlet weak var viewFullCostBox: UIView!
    @IBOutlet weak var imgviewFullCostSelection: UIImageView!
    @IBOutlet weak var lblFullCost: UILabel!
    
    @IBOutlet weak var imgviewUserAvatar: UIImageView!
    @IBOutlet weak var lblDonorName: UILabel!
    
    @IBOutlet weak var viewCreditCardBox: UIView!
    @IBOutlet weak var imgviewCreditCardSelection: UIImageView!
    @IBOutlet weak var viewPaypalBox: UIView!
    @IBOutlet weak var imgviewPaypalSelection: UIImageView!
    
    @IBOutlet weak var viewCreditCardInformationBox: UIView!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardExpirationDate: UITextField!
    @IBOutlet weak var txtCardSecurityCode: UITextField!
    @IBOutlet weak var switchRemember: UISwitch!
    @IBOutlet weak var viewPaymentCardField: STPPaymentCardTextField!
    
    
    @IBOutlet weak var viewContributionDonorNameBox: UIView!
    @IBOutlet weak var viewContributionAnonymousBox: UIView!
    @IBOutlet weak var imgviewContributionDonorNameSelection: UIImageView!
    @IBOutlet weak var imgviewContributionAnonymousSelection: UIImageView!
    
    @IBOutlet weak var btnDonate: UIButton!
    
    fileprivate var pickerYearMonth: MonthYearPickerView = MonthYearPickerView()
    
    var campaign: ESCampaignModel!
    
    fileprivate var imgCheckMark   = UIImage(named: "iconCkeckOption")
    fileprivate var imgUnckeckMark = UIImage(named: "iconUnckeckOption")
    fileprivate var isFullDonate = false
    fileprivate var isCreditCard = true
    fileprivate var isDonorName  = true
    
    fileprivate var cardNunmberFormatter: CHRTextFieldFormatter!
    
    fileprivate var paypalEnvironment: String = PayPalEnvironmentProduction /* PayPalEnvironmentSandbox */ {
        willSet (newEnviroment) {
            if newEnviroment != paypalEnvironment {
                PayPalMobile.preconnect(withEnvironment: newEnviroment)
            }
        }
    }
    fileprivate var paypalConfig = PayPalConfiguration()
    fileprivate var paypalResultText = ""
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = ESConstant.Color.BorderColor
        viewDonateCostBox.makeBorder(width: 0.5, color: borderColor)
        viewFullCostBox.makeBorder(width: 0.5, color: borderColor)
        
        imgviewUserAvatar.makeCircle()
        imgviewUserAvatar.makeBorder(width: 2, color: ESConstant.Color.Pink)
        
        btnDonate.makeRound()
        
        let tapFullDonate = UITapGestureRecognizer(target: self, action: #selector(onPressGesture(_:)))
        viewFullCostBox.addGestureRecognizer(tapFullDonate)
        
        let tapCreditCard = UITapGestureRecognizer(target: self, action: #selector(onPressGesture(_:)))
        viewCreditCardBox.addGestureRecognizer(tapCreditCard)
        
        let tapPaypal = UITapGestureRecognizer(target: self, action: #selector(onPressGesture(_:)))
        viewPaypalBox.addGestureRecognizer(tapPaypal)
        
        let tapDonorName = UITapGestureRecognizer(target: self, action: #selector(onPressGesture(_:)))
        viewContributionDonorNameBox.addGestureRecognizer(tapDonorName)
        
        let tapAnonymous = UITapGestureRecognizer(target: self, action: #selector(onPressGesture(_:)))
        viewContributionAnonymousBox.addGestureRecognizer(tapAnonymous)
        
        txtDonateCost.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        
        txtCardName.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        txtCardNumber.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        txtCardExpirationDate.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        txtCardSecurityCode.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        
        cardNunmberFormatter = CHRTextFieldFormatter(textField: txtCardNumber, mask: CHRCardNumberMask())
        
        // Student Name
        lblStudentName.text = String(format: "Fund %@ %@", campaign.firstName, campaign.lastName)
        
        // Donated percent
        let donatePercent = Float(campaign.totalPay / campaign.totalNeeds)
        progressPaid.progress = donatePercent
        
        // Remain Cost
        let remainCost = String(Int(campaign.totalNeeds - campaign.totalPay))
        lblTotalCost.text = String(format: "$%@", remainCost)
        
        txtDonateCost.placeholder = remainCost
        
        //
        let fullDonateText = NSMutableAttributedString(string: String(format: "$%@ to fully fund", remainCost))
        let boldFont = UIFont(name: ESConstant.FontName.Bold, size: 14)!
        let usernameRange = NSMakeRange(0, remainCost.characters.count + 1)
        fullDonateText.addAttributes([NSForegroundColorAttributeName : ESConstant.Color.Green,
                                      NSFontAttributeName: boldFont], range: usernameRange)
        lblFullCost.attributedText = fullDonateText
        
        // Donor
        let currentUser = appManager().currentUser!
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if let url = currentUser.profilePhoto, let imageURL = URL(string: url) {
            imgviewUserAvatar.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        } else {
            imgviewUserAvatar.image = placeholder
        }
        
        lblDonorName.text = String(format: "%@ %@", currentUser.firstName, currentUser.lastName)
        
        pickerYearMonth.onDateSelected = { (month, year) in
            let selectedDate = String(format: "%02d/%d", month, year)
            self.txtCardExpirationDate.text = selectedDate
            self.txtCardExpirationDate.makeBorder(width: 0.5, color: UIColor.clear)
        }
        txtCardExpirationDate.inputView = pickerYearMonth
//        viewPaymentCardField.numberPlaceholder = "Card number *"
//        viewPaymentCardField.cvcPlaceholder = "Security code *"
        
//        addTempararyData()
        
        configurationPaypal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllerTitle() -> String? {
        return "Donate"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: paypalEnvironment)
        
    }
    
    fileprivate func addTempararyData() {
        txtDonateCost.text = "12"
        txtCardName.text = "Test Donate card"
        txtCardNumber.text = "4242 4242 4242 4242"
        txtCardExpirationDate.text = "10/2018"
        txtCardSecurityCode.text = "123"
        
    }
    
    fileprivate func configurationPaypal() {
        let currentUser = appManager().currentUser!
        paypalConfig.acceptCreditCards = false
        paypalConfig.merchantName = String(format: "%@ %@", currentUser.firstName, currentUser.lastName)
        paypalConfig.languageOrLocale = Locale.preferredLanguages[0]
        paypalConfig.payPalShippingAddressOption = .payPal

    }
    
    // MARK: - UITableView datasource, delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return isCreditCard ? 300 : 80
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - UITextfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDonateCost {
            imgviewFullCostSelection.image = imgUnckeckMark
            isFullDonate = false
        } else if textField == txtCardExpirationDate {
            
//            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCardNumber {
            return cardNunmberFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return true
        }
    }
    
    func textFieldChanged(_ textField: UITextField) -> Void {
        
        let borderColor = ESConstant.Color.BorderColor
        if textField == txtDonateCost {
            viewDonateCostBox.makeBorder(width: 0.5, color: borderColor)
        } else if textField == txtCardName {
            txtCardName.makeBorder(width: 0.5, color: UIColor.clear)
        } else if textField == txtCardNumber {
            txtCardNumber.makeBorder(width: 0.5, color: UIColor.clear)
        } else if textField == txtCardSecurityCode {
            txtCardSecurityCode.makeBorder(width: 0.5, color: UIColor.clear)
        } else if textField == txtCardExpirationDate {
            txtCardExpirationDate.makeBorder(width: 0.5, color: UIColor.clear)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtDonateCost {
            textField.resignFirstResponder()
        } else if textField == txtCardName {
            txtCardNumber.becomeFirstResponder()
        } else if textField == txtCardNumber {
            txtCardExpirationDate.becomeFirstResponder()
        } else if textField == txtCardSecurityCode {
            txtCardSecurityCode.resignFirstResponder()
        } else if textField == txtCardExpirationDate {
            
        }
        return false
    }
    
    // MARK: - Tap gesture
    func onPressGesture(_ sender: UITapGestureRecognizer) -> Void {
        if let tapView = sender.view {
            if tapView == viewFullCostBox {
                txtDonateCost.resignFirstResponder()
                imgviewFullCostSelection.image = imgCheckMark
                isFullDonate = true
                viewDonateCostBox.makeBorder(width: 0.5, color: ESConstant.Color.BorderColor)
            } else if tapView == viewPaypalBox {
                imgviewCreditCardSelection.image = imgUnckeckMark
                imgviewPaypalSelection.image = imgCheckMark
                isCreditCard = false
//                viewCreditCardInformationBox.isHidden = true
                updateCreditCardInfoView()
            } else if tapView == viewCreditCardBox {
                imgviewCreditCardSelection.image = imgCheckMark
                imgviewPaypalSelection.image = imgUnckeckMark
                isCreditCard = true
//                viewCreditCardInformationBox.isHidden = false
                updateCreditCardInfoView()
            } else if tapView == viewContributionDonorNameBox {
                imgviewContributionDonorNameSelection.image = imgCheckMark
                imgviewContributionAnonymousSelection.image = imgUnckeckMark
                isDonorName = true
            } else if tapView == viewContributionAnonymousBox {
                imgviewContributionDonorNameSelection.image = imgUnckeckMark
                imgviewContributionAnonymousSelection.image = imgCheckMark
                isDonorName = false
            }
        }
    }
    
    fileprivate func updateCreditCardInfoView() {
        self.tableView.reloadData()
        /*
        let indexPath = IndexPath(row: 3, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade) */
    }
    
    // MARK: - Donate
    
    fileprivate func availablePaymentInfo() -> Bool {
        var isAvailable: Bool = true
        
        if isFullDonate == false {
            let remainCost = Int(campaign.totalNeeds - campaign.totalPay)
            if let costForDonate = Int(txtDonateCost.text!) {
                if costForDonate == 0 || costForDonate > remainCost {
                    isAvailable = false
                    viewDonateCostBox.makeBorder(width: 1, color: UIColor.red)
                }
            } else {
                isAvailable = false
                viewDonateCostBox.makeBorder(width: 1, color: UIColor.red)
            }
        }
        if isCreditCard {
            
            if txtCardName.text!.characters.count == 0 {
                isAvailable = false
                txtCardName.makeBorder(width: 1, color: UIColor.red)
            }
            if txtCardNumber.text!.characters.count < 15 {
                isAvailable = false
                txtCardNumber.makeBorder(width: 1, color: UIColor.red)
            }
            if txtCardExpirationDate.text!.characters.count < 7 {
                isAvailable = false
                txtCardExpirationDate.makeBorder(width: 1, color: UIColor.red)
            }
            if txtCardSecurityCode.text!.characters.count < 3 {
                isAvailable = false
                txtCardSecurityCode.makeBorder(width: 1, color: UIColor.red)
            }
//            isAvailable = viewPaymentCardField.isValid
        }
        
        return isAvailable
    }
    
    @IBAction func onPressDonate(_ sender: Any) {
        if availablePaymentInfo() {
            var donateCost: Int = 0
            if isFullDonate == false {
                donateCost = Int(txtDonateCost.text!)!
            } else {
                donateCost = Int(campaign.totalNeeds - campaign.totalPay)
            }
            let alertTitle = NSLocalizedString("Confirm", comment: "")
            let alertMessage = String(format: "Will you donate $%d? to %@ %@", donateCost, campaign.firstName, campaign.lastName)
            self.showAlert(title: alertTitle, message: alertMessage, okButtonTitle: "Sure", cancelButtonTitle: "Cancel", okClosure: { 
                if self.isCreditCard {
                    self.donateWithStripe(cost: donateCost)
                } else {
                    self.donateWithPaypal(cost: donateCost)
                }
            })
        }
    }

    fileprivate func donateWithStripe(cost: Int = 0) {
        
        self.view.endEditing(true)
        
        self.showLoadingIndicator()
        
        let cardParams = STPCardParams()
        cardParams.number = txtCardNumber.text!.replacingOccurrences(of: " ", with: "")
        let expDate = txtCardExpirationDate.text!
        cardParams.expMonth = UInt(expDate.substring(to: expDate.index(expDate.startIndex, offsetBy: 2)))!
        cardParams.expYear  = UInt(expDate.substring(from: expDate.index(expDate.startIndex, offsetBy: 3)))!
        cardParams.cvc = txtCardSecurityCode.text
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            if token != nil {
                self.submitDonateInfoForStripe(card: cardParams, cardName: self.txtCardName.text!, amount: cost, token: token!.tokenId)
            } else {
                self.showSimpleAlert(title: "Error", message: error?.localizedDescription, dismissed: { 
                    
                })
                self.stopLoadingIndicator()
            }
        }
    }
    
    fileprivate func donateWithPaypal(cost: Int = 0) {
        
//        let paypalItem = PayPalItem(name: "Donate", withQuantity: 1, withPrice: NSDecimalNumber(value: cost), withCurrency: "USD", withSku: nil)
        
        let donateDescription = String(format: "Donate to %@ %@", campaign.firstName, campaign.lastName)
        let paypalPayment = PayPalPayment(amount: NSDecimalNumber(value: cost), currencyCode: "USD", shortDescription: donateDescription, intent: .order)
        
        if paypalPayment.processable {
            let paymentVC = PayPalPaymentViewController(payment: paypalPayment, configuration: paypalConfig, delegate: self)!
            self.navigationController?.present(paymentVC, animated: true, completion: nil)
        } else {
            self.showSimpleAlert(title: "Error", message: "You can't proceed payment now because of have some error.", dismissed: nil)
        }
        
    }
    
    fileprivate func submitDonateInfoForStripe(card: STPCardParams, cardName: String?, amount: Int, token: String) {
        
        requestManager().paymentStripe(user: appManager().currentUser!,
                                       campaignId: campaign.cId,
                                       amount: amount,
                                       stripeToken: token,
                                       cardName: cardName,
                                       cardNumber: card.number,
                                       cardExpMonth: card.expMonth,
                                       cardExpYear: card.expYear,
                                       cardCVC: card.cvc,
                                       appearance: isDonorName) { (errorMessage: String?) in
            
                                        self.stopLoadingIndicator()
                                        
                                        if errorMessage == nil {
                                            
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                                            object: nil, userInfo: nil)

                                            self.showSimpleAlert(title: "Donated successfully!", message: "Thanks for your donation.", dismissed: {
                                                self.stopLoadingIndicator()
                                                

                                                _ = self.navigationController?.popViewController(animated: true)
                                                
                                            })

                                            
                                        } else {
                                            self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
                                            self.stopLoadingIndicator()
                                        }
                                        
        }
    }
    
    // MARK: - PayPal Payment Delegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        self.stopLoadingIndicator()
        paymentViewController.dismiss(animated: true, completion: nil)
        self.showSimpleAlert(title: "Canceled", message: "You have canceled payment transaction.", dismissed: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
        self.showLoadingIndicator()
        
        var donateCost: Int = 0
        if isFullDonate == false {
            donateCost = Int(txtDonateCost.text!)!
        } else {
            donateCost = Int(campaign.totalNeeds - campaign.totalPay)
        }
        
        // TODO: Change transaction id
        let transactionId = (completedPayment.confirmation["response"] as! [AnyHashable: Any])["id"] as! String
        
        requestManager().paymentPaypal(user: appManager().currentUser!, campaignId: campaign.cId, amount: donateCost, transactionId: transactionId) { (errorMessage: String?) in
            if errorMessage == nil {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.ReloadCampaigns),
                                                object: nil, userInfo: nil)
                
                self.showSimpleAlert(title: "Donated successfully!", message: "Thanks for your donation.", dismissed: {
                    self.stopLoadingIndicator()
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                })
                
                
            } else {
                self.showSimpleAlert(title: "Error", message: errorMessage, dismissed: nil)
            }
            
            self.stopLoadingIndicator()

        }
        
        
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, willComplete completedPayment: PayPalPayment, completionBlock: @escaping PayPalPaymentDelegateCompletionBlock) {
        
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
