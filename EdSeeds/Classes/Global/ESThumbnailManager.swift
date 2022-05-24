//
//  ESThumbnailManager.swift
//  EdSeeds
//
//  Created by BeautiStar on 2/13/17.
//  Copyright © 2017 BeautiStar. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class ESThumbnailManager: ESObject {
    static let sharedManager : ESThumbnailManager = {
        let instance = ESThumbnailManager()
        return instance
    }()

    fileprivate var downloadedImage: [String: Bool] = [:]
    
    func getThumbnail(url: String, complete:@escaping ((UIImage?) -> Void)) {
        SDImageCache.shared().queryCacheOperation(forKey: url) { (image: UIImage?, data: Data?, type: SDImageCacheType) in
            if image != nil {
                self.downloadedImage[url] = true
                complete(image!)
            } else {
                if self.downloadedImage[url] == nil {
                    self.downloadedImage[url] = false
                    
                    DispatchQueue.global(qos: .background).async {
                        let asset = AVURLAsset(url: URL(string: url)!)
                        let generator = AVAssetImageGenerator(asset: asset)
                        generator.appliesPreferredTrackTransform = true
                        do {
                            let imageRef = try generator.copyCGImage(at: CMTime(value: 1, timescale: 2), actualTime: nil)
                            let image = UIImage(cgImage: imageRef)
                            
                            DispatchQueue.main.async {
                                SDImageCache.shared().store(image, forKey: url, toDisk: true)
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ESConstant.Notification.DownloadedThumbnail), object: nil)
                                self.downloadedImage[url] = true
                                complete(image)
                            }
                            
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
}
