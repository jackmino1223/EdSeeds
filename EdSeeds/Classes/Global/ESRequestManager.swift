//
//  ESRequestManager.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ESRequestManager: NSObject {

    static let sharedManager : ESRequestManager = {
        let instance = ESRequestManager()
        return instance
    }()

    let baseURL: String = "http://35.163.249.175/Edseed"
//    let baseURL: String = "http://35.163.249.175/Edseed-Dev"
    let endpointAppLogin                = "/WS/App_Login"
    let endpointRegister                = "/WS/Register"
    let endpointEditStudentProfile      = "/WS/EditStudentProfile"
    let endpointEditDonorProfile        = "/WS/EditDonorProfile"
    let endpointEditAdvocateProfile     = "/WS/EditAdvocateProfile"
    let endpointAddSkill                = "/WS/addSkill"
    let endpointAddNewSkill             = "/WS/NewSkill"
    let endpointEndorseSkill            = "/WS/endorseSkill"
    let endpointRemoveEndorse           = "/WS/removeEndorse"
    let endpointGetProfileInfo          = "/WS/Profile"
    let endpointUserLogin               = "/WS/Login"
    let endpointAddCampaign             = "/WS/AddCampaign"
    let endpointEditCampaign            = "/WS/EditCampaign"
    let endpointLoadCampaignForDonor    = "/WS/loadcampaigns"
    let endpointLoadCampaignForGuest    = "/WS/loadcampaignsforguest"
    let endpointLoadStudentCampaign     = "/WS/loadUserCampaigns"
    let endpointLoadCampaignForAdvocate = "/WS/loadAdvocateCampaigns"
    let endpointUploadCampaignVideo     = "/WS/UploadVideo"
    let endpointDeleteVideo             = "/WS/DeleteVideo"
    let endpointLoadCampaignDetail      = "/WS/LoadCampaignDetails"
    let endpointChangePassword          = "/WS/ChangePassword"
    let endpointChangeProfilePhoto      = "/WS/ChangeProfilePhoto"
    let endpointRemoveStudentSkill      = "/WS/RemoveSkill"
    let endpointLogout                  = "/WS/Logout"
    let endpointGetCountries            = "/WS/GetCountries"
    let endpointGetSkills               = "/WS/GetSkills"
    let endpointGetInstitutions         = "/WS/GetInstitutions"
    let endpointSendShareNotification   = "/WS/sendShareNotification"
    let endpointForgotPassword          = "/WS/sendForgetPasswordCode"
    let endpointForgotPasswordVerify    = "/WS/checkForgetCode"
    let endpointForgotPasswordNewPass   = "/WS/forgetPassword"
    let endpointGetCountry              = "/WS/GetCountry"
    let endpointDeleteUser              = "/WS/deleteUser"
    let endpointRecreateToken           = "/WS/ReCreateToken"
    let endpointGetMajors               = "/WS/getMajors"
    let endpointGetDegrees              = "/WS/getDegrees"
    let endpointGetScholarshipPrograms  = "/WS/GetScholarshipPrograms"
    let endpointChangeAdvocateToDonor   = "/WS/changeAdvocateToDonor"
    let endpointGetStudentSkills        = "/WS/GetStudentSkills"
    let endpointGetNotifications        = "/WS/getNotifications"
    let endpointNotificationMarkAsRead  = "/WS/markNotificationsAsRead"
    let endpointCheckUserExist          = "/WS/checkUserExist"
    let endpointStripPayment            = "/WS/StripePayment"
    let endpointPaypalPayment           = "/WS/PaypalPayment"
    let endpointPaymentURL              = "/Payment/Index/%d/%d/%@"
    let endpointShareProfileLink        = "/Profile/Index/%d"
    let endpointGetReportTypes          = "/WS/getReportTypes"
    let endpointReportVideo             = "/WS/reportVideo"
    let endpointBlockUser               = "/WS/blockUser"
    let endpointUnblockUser             = "/WS/unblockuser"
    
    
    typealias CompleteResponse = (_ response: JSON?, _ errorMessage: String?, _ error: Error?) -> Void
    typealias ProgressClosure  = (Progress) -> Void
    typealias ErrorResponse = (Error?, JSON?) -> Void
    typealias UserResponse = (ESUserModel?, String?) -> Void
    typealias SimpleResponse = (String?) -> Void
    typealias BaseDataResponse = ([ESBaseObjectModel]?, String?) -> Void
    typealias StudentSkillResponse = ([ESStudentSkillModel]?, String?) -> Void
    
    struct Attachment {
        var fieldName: String!
        var file: Data?
        var fileURL: URL?
        var mimeType: String!
        var fileName: String!
    }
    
    func request(url: String, params: [String: String]?, attachments: [Attachment]? = nil, complete: @escaping CompleteResponse, uploadingProgress: ProgressClosure? = nil) -> Void {
        
        let requestURL = baseURL + url
        
        let requestResult: ((DataResponse<Any>) -> Void) = { (response: DataResponse<Any>) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                if jsonData.null == nil {
                    let result = jsonData["result"].intValue
                        if result == 0 {
                            complete(jsonData, nil, nil)
                        } else {
                            let errorMessage = jsonData["message"].string
                            complete(nil, errorMessage, nil)
                        }
//                    } else {
//                        complete(nil, "Unknown error", nil)
//                    }
                } else {
                    complete(nil, "Wrong response", nil)
                }
                
                break
            case .failure(let error):
                complete(nil, error.localizedDescription, error)
                break
            }

        }
        
        if attachments != nil {
            Alamofire.upload(multipartFormData: { (multiparFormData: MultipartFormData) in
                for attachment in attachments! {
                    if let data = attachment.file {
                        multiparFormData.append(data, withName: attachment.fieldName, fileName: attachment.fileName,  mimeType: attachment.mimeType)
                    } else if let url = attachment.fileURL {
                        multiparFormData.append(url, withName: attachment.fieldName, fileName: attachment.fileName,  mimeType: attachment.mimeType)
                    }
                }
                if params != nil {
                    for (key, value) in params! {
                        if let data = value.data(using: .utf8) {
                            multiparFormData.append(data, withName: key)
                        }
                    }
                }
            },
             to: requestURL,
             encodingCompletion: { (result: SessionManager.MultipartFormDataEncodingResult) in
                switch result {
                case .success(let upload, _, _):
                    
                    if uploadingProgress != nil {
                        upload.uploadProgress(queue: DispatchQueue.main, closure: uploadingProgress!)
                    }
                    
                    upload.responseJSON(completionHandler: requestResult)
                    
                    break
                case .failure(let error):
                    complete(nil, error.localizedDescription, error)
                    break
                    
                }
            })
        } else {
            
            Alamofire.request(requestURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: requestResult)
            
        }
    }
    
    func requestForAppToken(_ complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "app_username" : "EdSeed",
            "app_key" : "EdSeed_@)!!_@@",
        ]
        request(url: endpointAppLogin, params: params, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                complete(nil)
            } else {
                complete(errorMessage)
            }
        })
    }
    
    private func requestForUser(url: String, params: [String: String], attachment: Attachment? = nil, complete: @escaping UserResponse) -> Void {
        var attachments: [Attachment]? = nil
        if attachment != nil {
            attachments = [attachment!]
        }
        
        request(url: url, params: params, attachments: attachments, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                let user = ESUserModel(json: result!["user_data"])
                user.token = result!["token"].stringValue
                complete(user, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }
    
    private func requestForSimpleResponse(url: String, params: [String: String], attachment: Attachment? = nil, complete: @escaping SimpleResponse) {
        var attachments: [Attachment]? = nil
        if attachment != nil {
            attachments = [attachment!]
        }
        
        request(url: url, params: params, attachments: attachments, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                complete(nil)
            } else {
                complete(errorMessage)
            }
        })
    }
    
    private func requestForBasedatas(url: String, resultFieldName: String, complete: @escaping BaseDataResponse) {
        request(url: url, params: nil, complete:  { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                var datas: [ESBaseObjectModel] = []
                for jsonElem in result![resultFieldName].arrayValue {
                    datas.append(ESBaseObjectModel(json: jsonElem))
                }
                complete(datas, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }
    
    private func getVideoThumbnail(from: URL?) -> UIImage? {
        if let url = from {
            let asset = AVURLAsset(url: url)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    func checkUserExist(email: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "email": email
        ]
        requestForSimpleResponse(url: endpointCheckUserExist, params: params, complete: complete)
    }

    func register(type: UserType,
                  email: String,
                  password: String?,
                  deviceToken: String?,
                  authType: AuthType,
                  authId: String?,
                  photo: UIImage?,
                  extraParams: [String: Any]?,
                  complete: @escaping UserResponse)
        -> Void {
            var params: [String: String] = [
                "u_type": type.rawValue,
                "u_app_id": deviceToken ?? "no_app_id",
                "u_platform" : "iOS",
                "u_auth_type" : String(authType.rawValue),
                "u_email" : email,
            ]
            if authType != .Default {
                params["u_auth_id"] = authId ?? ""
            }
            if password == nil {
                params["u_password"] = ""
            } else {
                params["u_password"] = password!
            }
            if extraParams != nil {
                for (key, value) in extraParams! {
                    if value is Int {
                        params[key] = String(value as! Int)
                    } else if value is String {
                        params[key] = value as? String
                    }
                }
            }
            
            var attachment: Attachment? = nil
            if photo != nil {
                attachment = Attachment()
                attachment!.fieldName = "photo"
                attachment!.file = UIImageJPEGRepresentation(photo!, 0.8)!
                attachment!.fileName = "avatar.jpg"
                attachment!.mimeType = "image/jpeg"
            }
            
            requestForUser(url: endpointRegister, params: params, attachment: attachment, complete: complete)
            
    }
    
    func login(email: String, password: String? = nil, authId: String? = nil, deviceToken: String? = nil, complete: @escaping UserResponse) -> Void {
        
        var params: [String: String] = [
            "email": email,
        ]
        
        if password != nil {
            params["password"] = password!
        } else if authId != nil {
            params["auth_id"] = authId!
        }
        if deviceToken != nil {
            params["app_id"] = deviceToken!
        }
        requestForUser(url: endpointUserLogin, params: params, complete: complete)

    }
    
    func logout(complete: @escaping SimpleResponse) -> Void {
        requestForSimpleResponse(url: endpointLogout, params: [:], complete: complete)
    }
    
    func forgetPassword(email: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_email": email
        ]
        requestForSimpleResponse(url: endpointForgotPassword, params: params, complete: complete)
    }
    
    func forgetPassword(email: String, verifyCode: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_email": email,
            "forget_code": verifyCode
        ]
        requestForSimpleResponse(url: endpointForgotPasswordVerify, params: params, complete: complete)
    }
    
    func forgetPassword(email: String, newPassword: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_email": email,
            "password": newPassword
        ]
        requestForSimpleResponse(url: endpointForgotPasswordNewPass, params: params, complete: complete)
    }
    
    func recreateToken(userId: Int, complete: @escaping UserResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(userId)
        ]
        requestForUser(url: endpointRecreateToken, params: params, complete: complete)
    }
    
    func editProfile(user: ESUserModel, extraParams: [String: Any], complete: @escaping UserResponse) -> Void {
        var params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            ]
        for (key, value) in extraParams {
            if value is Int {
                params[key] = String(value as! Int)
            } else if value is String {
                params[key] = value as? String
            }
        }
        var requestURL: String!
        let userType = user.type
        if userType == .studuent {
            requestURL = endpointEditStudentProfile
        } else if userType == .donor {
            requestURL = endpointEditDonorProfile
        } else if userType == .advocate {
            requestURL = endpointEditAdvocateProfile
        } else {
            complete(nil, "Unknown User type")
            return
        }
        
        requestForUser(url: requestURL, params: params, complete: complete)

    }
    
    func changeUserAvatar(user: ESUserModel, avatar: UIImage, complete: @escaping UserResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            ]
        let photoData = UIImageJPEGRepresentation(avatar, 0.8)!
        let attachment = Attachment(fieldName: "photo", file: photoData, fileURL: nil, mimeType: "image/jpeg", fileName: "avatar.jpg")
        requestForUser(url: endpointChangeProfilePhoto, params: params, attachment: attachment, complete: complete)
    }
    
    func getProfile(userId: Int, complete: @escaping UserResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(userId),
        ]
        
        requestForUser(url: endpointGetProfileInfo, params: params, complete: complete)
    }
    
    func addSkill(user: ESUserModel, skill: ESBaseObjectModel, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "skill_id": String(skill.id)
        ]
        
        requestForSimpleResponse(url: endpointAddSkill, params: params, complete: complete)
    }
    
    func addSkill(user: ESUserModel, skillId: Int, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "skill_id": String(skillId)
        ]
        
        requestForSimpleResponse(url: endpointAddSkill, params: params, complete: complete)
    }
    
    func removeSkill(user: ESUserModel, skillId: Int, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "skill_id": String(skillId)
        ]
        requestForSimpleResponse(url: endpointRemoveStudentSkill, params: params, complete: complete)

    }
    
    func addNewSkill(user: ESUserModel, skillName: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "skill": skillName
        ]
        requestForSimpleResponse(url: endpointAddNewSkill, params: params, complete: complete)
    }

    
    func endroseSkill(user: ESUserModel, toUser: ESUserModel, skill: ESBaseObjectModel, complete: @escaping SimpleResponse) -> Void {
        
    }
    
    func removeEndorse(user: ESUserModel, toUser: ESUserModel, skill: ESBaseObjectModel, complete: @escaping SimpleResponse) -> Void {
        
    }
    
    fileprivate func requestForCampaign(user: ESUserModel,
                                        campaignId: Int? = nil,
                                        totalNeeds: Double,
                                        dueDate: String,
                                        name: String,
                                        details: String,
                                        video: URL?,
                                        photo: UIImage?,
                                        progress: ProgressClosure?,
                                        complete: @escaping SimpleResponse) -> Void {
        
        var params: [String: String] = [
            "st_id": String(user.uId),
            "st_token": user.token!,
            "total_needs": String(totalNeeds),
            "due_date": dueDate,
            "details": details,
            "name": name,
            ]
        if campaignId != nil {
            params["cam_id"] = String(campaignId!)
        }
//        var attachment: Attachment? = nil
        var attachments: [Attachment] = []
        
        if video != nil {
            var attachment = Attachment()
            attachment.fileURL = video
            attachment.fileName = "campaignvideo.mov"
            attachment.fieldName = "video"
            attachment.mimeType = "video/quicktime"
            attachments.append(attachment)
        }
        if photo != nil {
            var attachment = Attachment()
            attachment.file = UIImageJPEGRepresentation(photo!, 0.8)
            attachment.fileName = "thumbnail.jpg"
            attachment.fieldName = "photo"
            attachment.mimeType = "image/jpeg"
            attachments.append(attachment)
        }
        
        var requestURL: String!
        if campaignId == nil {
            requestURL = endpointAddCampaign
        } else {
            requestURL = endpointEditCampaign
        }
        request(url: requestURL, params: params, attachments: attachments, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                complete(nil)
            } else {
                complete(errorMessage)
            }
        }, uploadingProgress: progress)

        
    }
    
    func addCampaign(user: ESUserModel,
                     totalNeeds: Double,
                     dueDate: String,
                     name: String,
                     details: String,
                     video: URL?,
//                     photo: UIImage?,
                     progress: ProgressClosure?,
                     complete: @escaping SimpleResponse) -> Void
    {
        requestForCampaign(user: user,
                           totalNeeds: totalNeeds,
                           dueDate: dueDate,
                           name: name,
                           details: details,
                           video: video,
                           photo: getVideoThumbnail(from: video),
                           progress: progress,
                           complete: complete)
    }
    
    func editCampaign(user: ESUserModel,
                      campaignId: Int,
                      totalNeeds: Double,
                      dueDate: String,
                      name: String,
                      details: String,
                      video: URL?,
//                      photo: UIImage?,
                      progress: ProgressClosure?,
                      complete: @escaping SimpleResponse) -> Void {
        
        requestForCampaign(user: user,
                           campaignId: campaignId,
                           totalNeeds: totalNeeds,
                           dueDate: dueDate,
                           name: name,
                           details: details,
                           video: video,
                           photo: getVideoThumbnail(from: video),
                           progress: progress,
                           complete: complete)
    }
    
    func loadCampaign(forUser: ESUserModel?,
                      keyword: String? = nil,
                      page: Int? = nil,
                      locationIds: [Int]? = nil,
                      universityIds: [Int]? = nil,
                      degreeIds: [Int]? = nil,
                      majorIds: [Int]? = nil,
                      scholarshipProgramsIds: [Int]? = nil,
                      studentId: Int? = nil,
                      complete: @escaping (([ESCampaignModel]?, String?) -> Void) ) -> Void {
        
        var requestURL: String!
        var params: [String: String] = [:]
        if forUser != nil {
            if forUser!.type == .studuent {
                requestURL = endpointLoadStudentCampaign
            } else if forUser!.type == .donor {
                requestURL = endpointLoadCampaignForDonor
            } else if forUser!.type == .advocate {
                requestURL = endpointLoadCampaignForDonor //endpointLoadCampaignForAdvocate
                if studentId != nil {
                    params["st_id"] = String(studentId!)
                }
            } else {
                complete(nil, "Wrong user type")
            }
            params["u_id"] = String(forUser!.uId)
            params["u_token"] = forUser!.token!
        } else {
            requestURL = endpointLoadCampaignForGuest
        }
        
        if keyword != nil {
            requestURL = endpointLoadCampaignForDonor
            params["keyword"] = keyword!
        }
        if page != nil {
            params["page"] = String(page!)
        }
        if locationIds != nil {
            params["locations"] = locationIds!.map({ (elem: Int) -> String in
                return String(elem)
            }).joined(separator: ",")
        }
        if universityIds != nil {
            params["institutions"] = universityIds!.map({ (elem: Int) -> String in
                return String(elem)
            }).joined(separator: ",")
        }
        if degreeIds != nil {
            params["degrees"] = degreeIds!.map({ (elem: Int) -> String in
                return String(elem)
            }).joined(separator: ",")
        }
        if majorIds != nil {
            params["majors"] = majorIds!.map({ (elem: Int) -> String in
                return String(elem)
            }).joined(separator: ",")
        }
        if scholarshipProgramsIds != nil {
            params["programs"] = scholarshipProgramsIds!.map({ (elem: Int) -> String in
                return String(elem)
            }).joined(separator: ",")
        }
        request(url: requestURL, params: params, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                var campaigns: [ESCampaignModel] = []
                for jsonCampaign in result!["campaigns"].arrayValue {
                    campaigns.append(ESCampaignModel(json: jsonCampaign))
                }
                complete(campaigns, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }
    
    func loadCampaignDetail(campaign: ESCampaignModel, complete: @escaping ((ESCampaignModel?, String?) -> Void)) -> Void {
        let params: [String: String] = [
//            "u_id": String(user.uId),
//            "u_token": user.token!,
            "cam_id": String(campaign.cId),
        ]
        request(url: endpointLoadCampaignDetail, params: params, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                let detailCampaign = ESCampaignModel(json: result!)
                campaign.name = detailCampaign.name
                campaign.videos = detailCampaign.videos
                complete(campaign, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }

    func getCountries(complete: @escaping ([ESCountryModel]?, String?) -> Void) -> Void {
        request(url: endpointGetCountries, params: nil, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                var countries: [ESCountryModel] = []
                for jsonElem in result!["countries"].arrayValue {
                    countries.append(ESCountryModel(json: jsonElem))
                }
                complete(countries, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }
    
    func getSkills(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetSkills, resultFieldName: "skills", complete: complete)
    }
    
    func getInstitutions(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetInstitutions, resultFieldName: "institutions", complete: complete)
    }
    
    func getMajors(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetMajors, resultFieldName: "majors", complete: complete)
    }
    
    func getDegrees(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetDegrees, resultFieldName: "degrees", complete: complete)
    }
    
    func getScholarshipPrograms(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetScholarshipPrograms, resultFieldName: "scholarship_prgs", complete: complete)
    }
    
    func getReportTypes(complete: @escaping BaseDataResponse) -> Void {
        requestForBasedatas(url: endpointGetReportTypes, resultFieldName: "types", complete: complete)
    }
    
    func getStudentSkills(user: ESUserModel, complete: @escaping StudentSkillResponse) -> Void {
        let params: [String: String] = [
            "st_id": String(user.uId)
        ]
        requestForStudentSkill(params: params, complete: complete)
    }
    
    func getStudentSkills(studentId: Int, complete: @escaping StudentSkillResponse) -> Void {
        let params: [String: String] = [
            "st_id": String(studentId)
        ]
        requestForStudentSkill(params: params, complete: complete)
    }
    
    fileprivate func requestForStudentSkill(params: [String: String], complete: @escaping StudentSkillResponse) {
        request(url: endpointGetStudentSkills, params: params, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                var studentSkills: [ESStudentSkillModel] = []
                for jsonElem in result!["student_skills"].arrayValue {
                    studentSkills.append(ESStudentSkillModel(json: jsonElem))
                }
                complete(studentSkills, nil)
            } else {
                complete(nil, errorMessage)
            }
        })
    }
    
    
    func changeAdvocateToDonor(user: ESUserModel, complete: @escaping UserResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_tokne": user.token!,
        ]
        requestForUser(url: endpointChangeAdvocateToDonor, params: params, complete: complete)
    }
    
    func endorseSkill(user: ESUserModel, studentSkill: ESStudentSkillModel, endorse: Bool, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "id" : String(studentSkill.studentSkillId),
        ]
        let requestURL = endorse ? endpointEndorseSkill : endpointRemoveEndorse
        requestForSimpleResponse(url: requestURL, params: params, complete: complete)
    }
    
    func getSeedUrl(user: ESUserModel, studentId: Int) -> String? {
        let requestURL = String(format: baseURL + endpointPaymentURL, user.uId, studentId, user.token!)
        return requestURL
    }
    
    func getPublicProfileLink(studentId: Int) -> String? {
        let link = String(format: baseURL + endpointShareProfileLink, studentId)
        return link
    }
    
    func getNotification(user: ESUserModel, complete: @escaping (([ESNotificationModel]?, Int?, String?) -> Void)) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
        ]
        request(url: endpointGetNotifications, params: params, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                var notifications: [ESNotificationModel] = []
                for jsonElem in result!["Notifications"].arrayValue {
                    notifications.append(ESNotificationModel(json: jsonElem))
                }
                complete(notifications, result!["last_id"].intValue, nil)
            } else {
                complete(nil, nil, errorMessage)
            }
        })
    }
    
    func readedNotification(user: ESUserModel, lastId: Int, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "last_id": String(lastId)
        ]
        requestForSimpleResponse(url: endpointNotificationMarkAsRead, params: params, complete: complete)
    }
    
    func uploadVideo(user: ESUserModel,
                     campaignId: Int,
                     title: String,
                     videoDescription: String?,
                     videoURL: URL,
                     progress: ProgressClosure?,
                     complete: @escaping ((String?, String?) -> Void)) -> Void {
        
        var params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "cam_id": String(campaignId),
            "title": title
        ]
        if videoDescription != nil {
            params["desc"] = videoDescription!
        }
        var attachments: [Attachment] = []
        let videoAttachment = Attachment(fieldName: "video", file: nil, fileURL: videoURL, mimeType: "video/quicktime", fileName: "video.mov")
        attachments.append(videoAttachment)
        if let thumbnail = getVideoThumbnail(from: videoURL) {
            let data = UIImageJPEGRepresentation(thumbnail, 0.8)
            let photoAttachment = Attachment(fieldName: "photo", file: data, fileURL: nil, mimeType: "image/jpeg", fileName: "thumbnail.jpg")
            attachments.append(photoAttachment)
        }
        
        request(url: endpointUploadCampaignVideo, params: params, attachments: attachments, complete: { (result: JSON?, errorMessage: String?, error: Error?) in
            if result != nil {
                let videoPath = result!["video_path"].stringValue
                complete(videoPath, nil)
            } else {
                complete(nil, errorMessage)
            }
        }, uploadingProgress: progress)
        
    }
    
    func paymentStripe(user: ESUserModel,
                       campaignId: Int,
                       amount: Int,
                       stripeToken: String,
                       cardName: String?,
                       cardNumber: String?,
                       cardExpMonth: UInt?,
                       cardExpYear: UInt?,
                       cardCVC: String?,
                       appearance: Bool,
                       complete: @escaping SimpleResponse) -> Void {
        
        var params: [String: String] = [
            "u_id"      : String(user.uId),
            "u_token"   : user.token!,
            "amount"    : String(amount),
            "cam_id"    : String(campaignId),
            "appearance": appearance ? "1" : "0",
            "pay_token" : stripeToken,
            "saved"     : "0"
        ]
        if cardName != nil {
            params["holder_name"] = cardName!
        }
        if cardNumber != nil {
            params["card_number"] = cardNumber!
        }
        if cardExpMonth != nil {
            params["exp_month"] = String(cardExpMonth!)
        }
        if cardExpYear != nil {
            params["exp_year"] = String(cardExpYear!)
        }
        if cardCVC != nil {
            params["cvc"] = cardCVC!
        }
        
        requestForSimpleResponse(url: endpointStripPayment, params: params, complete: complete)
        
    }
    
    func paymentPaypal(user: ESUserModel,
                       campaignId: Int,
                       amount: Int,
                       transactionId: String,
                       complete: @escaping SimpleResponse) -> Void {
        
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "amount": String(amount),
            "cam_id": String(campaignId),
            "payment_trans": transactionId,
            ]
        
        requestForSimpleResponse(url: endpointPaypalPayment, params: params, complete: complete)
    }
    
    func reportVideo(user: ESUserModel?, videoId: Int, reportTypeId: Int, complete: @escaping SimpleResponse) -> Void {
        var params: [String: String] = [
            "video_id": String(videoId),
            "report_type": String(reportTypeId),
            ]
        if user != nil {
            params["u_id"] = String(user!.uId)
            params["u_token"] = user!.token!
        }
        requestForSimpleResponse(url: endpointReportVideo, params: params, complete: complete)
    }
    
    func blockUser(user: ESUserModel, blockUserId: Int, reason: String, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "blocked_user": String(blockUserId),
            "block_reason": reason,
            ]
        requestForSimpleResponse(url: endpointBlockUser, params: params, complete: complete)
    }
    
    func unblockUser(user: ESUserModel, blockUserId: Int, complete: @escaping SimpleResponse) -> Void {
        let params: [String: String] = [
            "u_id": String(user.uId),
            "u_token": user.token!,
            "blocked_user": String(blockUserId),
            ]
        requestForSimpleResponse(url: endpointUnblockUser, params: params, complete: complete)
    }
}
