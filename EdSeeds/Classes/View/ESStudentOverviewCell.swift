//
//  ESStudentOverviewCell.swift
//  EdSeeds
//
//  Created by BeautiStar on 1/19/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import GTProgressBar
import AlamofireImage
//import AVFoundation
import SnapKit
//import BMPlayer
import TWRProgressView

let ESStudentOverviewCellIdentifer = "ESStudentOverviewCell"

class ESStudentOverviewCell: ESTableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewUserInfoContainer: UIView!
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var lblUniversity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    
    @IBOutlet weak var viewVideoContainer: UIView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var imgviewThumbnail: UIImageView!
    
    @IBOutlet weak var viewProgressContainer: UIView!
//    @IBOutlet weak var imgviewProgressBackground: UIImageView!
//    @IBOutlet weak var imgviewProgressDot: UIImageView!
    @IBOutlet weak var remainDaysProgress: TWRProgressView!
    
    @IBOutlet weak var btnEndrose: UIButton!
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var btnShareProfile: UIButton!
    @IBOutlet weak var progressSeeders: GTProgressBar!
    @IBOutlet weak var lblSeeders: UILabel!
    @IBOutlet weak var lblSeederPercent: UILabel!
    @IBOutlet weak var lblRemainDays: UILabel!
    @IBOutlet weak var viewSubmenu: UIView!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnReportVideo: UIButton!
    @IBOutlet weak var btnBlockUser: UIButton!
    @IBOutlet weak var constraintTopSpaceOfMain: NSLayoutConstraint!
    
    var delegate: ESStudentOverviewCellDelegate?
    
    var videoPlayer: BMPlayer?
//    fileprivate var playerItem: BMPlayerItem!
    
//    weak var videoPlayer: AVPlayer!
    
    var campaign: ESCampaignModel! {
        didSet {
            showCampaign()
        }
    }
    
    /*
    var playerItem : AVPlayerItem! {
        didSet {
            self.setPlayerItem()
        }
    } */
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAvatar.makeCircle()
        imgAvatar.makeBorder(width: 2, color: ESConstant.Color.Pink)
        
        btnDonate.makeCircle()
        btnDonate.makeBorder(width: 2, color: UIColor.white)
        
        viewSubmenu.isHidden = true
        
        remainDaysProgress.maskingImage = UIImage(named: "iconDotProgressBackground")
        remainDaysProgress.isHorizontal = true
        remainDaysProgress.setBackColor(UIColor.clear)
        remainDaysProgress.colors = [ESConstant.Color.Green, UIColor.lightGray ]
//        readdVideoPlayerView()
        
        /*
        let player = AVPlayer()
        
        let playerlayer = AVPlayerLayer(player: player)
        playerlayer.frame = viewVideoContainer.bounds
        viewVideoContainer.layer.addSublayer(playerlayer)
        videoPlayer = player */
        
        if let currentUser = ESAppManager.sharedManager.currentUser, currentUser.type == .studuent {
            btnDonate.setTitle("+", for: .normal)
            btnDonate.titleLabel?.font = UIFont(name: ESConstant.FontName.Bold, size: 40)
        } else {
            btnDonate.setTitle("SEED", for: .normal)
            btnDonate.titleLabel?.font = UIFont(name: ESConstant.FontName.Bold, size: 13)
        }
        if ESAppManager.sharedManager.currentUser == nil {
            self.btnBlockUser.isHidden = true
        }
    }
    
    fileprivate func showCampaign() {
        let placeholder = UIImage(named: ESConstant.ImageFileName.userAvatarLight)
        if let url = campaign.profilePhoto, let imageURL = URL(string: url) {
            imgAvatar.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        } else {
            imgAvatar.image = placeholder
        }
        lblStudentName.text = String(format: "%@ %@", campaign.firstName, campaign.lastName)
        lblUniversity.text = campaign.instName
        lblCountry.text = String(format: "%@ - %@ - %@", campaign.location ?? "", campaign.degree ?? "", campaign.major ?? "")
        
        var seeders: String!
        if campaign.totalDonors == 0 {
            seeders = "NO SEEDERS"
        } else if campaign.totalDonors == 1 {
            seeders = "1 SEEDER"
        } else {
            seeders = String(format: "%d SEEDERS", campaign.totalDonors)
        }
        
        lblSeeders.text = seeders
        let percent = (campaign.totalPay / campaign.totalNeeds * 100)
        lblSeederPercent.text = String(format: "%.0f %%", percent)
        progressSeeders.progress = CGFloat(percent / 100)
        
        if let dueDate = ESConstant.ESDateFormatter.OnlyDate.date(from: campaign.dueDate) {
            var remainDays = ESAppManager.calculateDaysBetweenTwoDates(start: Date(), end: dueDate)
            
            if remainDays < 0 {
                remainDays = 0
            }
            
            var remainDaysString: String!
            if remainDays == 0 {
                remainDaysString = "Expired"
            } else if remainDays == 1 {
                remainDaysString = "1 DAY"
            } else {
                remainDaysString = String(format: "%d DAYS", remainDays)
            }
            
            self.lblRemainDays.text = remainDaysString
            var percentDay: CGFloat = CGFloat(30 - remainDays) / 30.0
            if percentDay > 1.0 {
                percentDay = 1.0
            } else if percentDay < 0 {
                percentDay = 0
            }
            remainDaysProgress.setProgress(percentDay)
//            self.imgviewProgressDot.image = dotProgressImage(forPercent: percentDay)
        } else {
            self.lblRemainDays.text = "Expired"
            remainDaysProgress.setProgress(1.0)
//            self.imgviewProgressDot.image = nil
        }
        viewSubmenu.isHidden = true
        
        readVideoPlayerView()
        
//        videoPlayer?.resetPlayer()
        /* 
        if let videoURLstring = campaign.video, let videoURL = URL(string: videoURLstring) {
            videoPlayer!.playWithURL(videoURL)
        } else {
            videoPlayer.prepareToDealloc()
        } */

    }
    
    fileprivate func dotProgressImage(forPercent: Float) -> UIImage {
        
        let imgProgress = UIImage(named: "iconDotProgressBackground")!
        let imgMask     = UIImage(named: "iconDotProgress")! //.cgImage!
        if forPercent == 0 {
            return imgMask
        } else if forPercent == 1 {
            return imgProgress
        } else {
            let cgImageMask = imgMask.cgImage!
            let mask = CGImage(maskWidth: Int(Float(cgImageMask.width) * forPercent),
                               height: cgImageMask.height,
                               bitsPerComponent: cgImageMask.bitsPerComponent,
                               bitsPerPixel: cgImageMask.bitsPerPixel,
                               bytesPerRow: cgImageMask.bytesPerRow,
                               provider: cgImageMask.dataProvider!,
                               decode: nil,
                               shouldInterpolate: false)
            if let maskedImageRef = mask?.masking(imgMask.cgImage!) {
                let finalImage = UIImage(cgImage: maskedImageRef)
                return finalImage
            } else {
                return imgProgress
            }
        }
    }
    
    fileprivate func showDotProgress(percent: Float) {
        

        
    }
    
    fileprivate func readVideoPlayerView() {
        if videoPlayer != nil {
            videoPlayer!.removeFromSuperview()
        }
        
        if let videoURLstring = campaign.video, let videoURL = URL(string: videoURLstring) {
            let player = BMPlayer()
            self.viewVideoContainer.insertSubview(player, belowSubview: imgviewThumbnail)
//            self.viewVideoContainer.addSubview(player)
            player.snp.makeConstraints { (maker: ConstraintMaker) in
                maker.left.top.right.bottom.equalToSuperview()
                
            }
            player.setContentHuggingPriority(240, for: .vertical)
            
            videoPlayer = player
            
            
            player.playStateDidChange = { (isPlaying: Bool) in
                self.btnPlayVideo.isHidden = isPlaying
                self.imgviewThumbnail.isHidden = isPlaying
            }
            
            player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
                
            }
            
            player.backBlock = nil

            videoPlayer!.playWithURL(videoURL)
            btnPlayVideo.isHighlighted = false
            btnPlayVideo.isEnabled = true
            btnPlayVideo.setImage(UIImage(named: "iconVideoPlay"), for: .normal)
            
            self.imgviewThumbnail.image = nil
            self.imgviewThumbnail.sd_setImage(with: URL(string: campaign.photo ?? ""))
            /*
            ESThumbnailManager.sharedManager.getThumbnail(url: videoURLstring, complete: { (image: UIImage?) in
                self.imgviewThumbnail.image = image
            }) */
        } else {
            btnPlayVideo.isHighlighted = true
            btnPlayVideo.isEnabled = false
            btnPlayVideo.setImage(nil, for: .normal)
            self.imgviewThumbnail.image = nil
        }

    }
    
    
    fileprivate func setPlayerItem() {
        
    }
    
    @IBAction func onPressPlayVideo(_ sender: Any) {
//        videoPlayer.play()
        if let videoURLstring = campaign.video, let _ = URL(string: videoURLstring) {
            videoPlayer!.play()
            btnPlayVideo.isHidden = true
            imgviewThumbnail.isHidden = true
            ESAppManager.sharedManager.activeVideoPlayer = videoPlayer
        }
        
    }
    
    @IBAction func onPressMore(_ sender: Any) {
        viewSubmenu.isHidden = !viewSubmenu.isHidden
    }
    
    @IBAction func onPressViewProfile(_ sender: Any) {
        delegate?.studentCellViewProfile(self)
    }
    
    @IBAction func onPressReportVideo(_ sender: Any) {
        delegate?.studentCellReportVideo(self)
        viewSubmenu.isHidden = true
    }
    
    @IBAction func onPressBlockUser(_ sender: Any) {
        delegate?.studentCellBlockUser(self, block: true)
        viewSubmenu.isHidden = true
    }
    
    @IBAction func onPressEndrose(_ sender: Any) {
        delegate?.studentCellEndrose(self)
    }
    
    @IBAction func onPressShare(_ sender: Any) {
        delegate?.studentCellShare(self)
    }
    
    @IBAction func onPressSeed(_ sender: Any) {
        delegate?.studentCellSeed(self)
    }
    
    func hideUserInfo() -> Void {
        imgAvatar.isHidden = true
        viewUserInfoContainer.isHidden = true
        btnOptions.isHidden = true
        constraintTopSpaceOfMain.constant = 0
        updateConstraints()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

protocol ESStudentOverviewCellDelegate {
    func studentCellEndrose(_ cell: ESStudentOverviewCell) -> Void
    func studentCellShare(_ cell: ESStudentOverviewCell) -> Void
    func studentCellViewProfile(_ cell: ESStudentOverviewCell) -> Void
    func studentCellSeed(_ cell: ESStudentOverviewCell) -> Void
    func studentCellReportVideo(_ cell: ESStudentOverviewCell) -> Void
    func studentCellBlockUser(_ cell: ESStudentOverviewCell, block: Bool) -> Void
}
