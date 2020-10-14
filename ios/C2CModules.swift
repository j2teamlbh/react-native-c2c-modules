@objc(C2CModules)
class C2CModules: NSObject {
    
    func convertToId(url: String) -> String {
        if url.contains("ph://") {
            let start = url.index(url.startIndex, offsetBy: 5)
            if url.count > 41 {
                let end = url.index(url.startIndex, offsetBy: 41)
                let range = start..<end
                return "\(url[range])"
            } else {
                return ""
            }
        } else {
            return url
        }
    }
    
    @objc(convertPHAsset:withResolver:withRejecter:)
    func convertPHAsset(params: NSDictionary, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        let phAsset:String = RCTConvert.nsString(params["id"])
//        let qualityVideo:String = RCTConvert.nsString(params["quality"])
        //Todo
        let mediaId = convertToId(url: phAsset)
        if mediaId.count < 36 {
            let error = NSError(domain: "", code: -91, userInfo: nil)
            reject("ERROR_FOUND", "Invalid URL", error)
            return;
        }
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [mediaId], options: nil)
        let fileName = UUID().uuidString
        if let phAsset = fetchResult.firstObject {
            PHImageManager.default().requestAVAsset(forVideo: phAsset, options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
                if let asset = asset as? AVURLAsset {
                    //                    let videoData = NSData(contentsOf: asset.url)
                    let videoPath = NSTemporaryDirectory() + "\(fileName).mp4"
                    let videoURL = NSURL(fileURLWithPath: videoPath)
                    let avAsset = AVURLAsset(url: videoURL as URL, options: nil)
                    if #available(iOS 10.0, *) {
                        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).mp4")
                        if let session = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) {
                            session.outputURL = outputURL
                            session.outputFileType = AVFileType.mp4
                            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
                            let range = CMTimeRangeMake(start: start, duration: asset.duration)
                            session.timeRange = range
                            session.shouldOptimizeForNetworkUse = true
                            session.exportAsynchronously {
                                switch session.status {
                                case .completed:
                                    resolve("Output: \(outputURL)")
                                case .cancelled:
                                    let error = NSError(domain: "", code: -94, userInfo: nil)
                                    reject("ERROR_FOUND", "Video export cancelled.", error)
                                case .failed:
                                    let errorMessage = session.error?.localizedDescription ?? "n/a"
                                    let error = NSError(domain: "", code: -95, userInfo: nil)
                                    reject("ERROR_FOUND", "Video export failed with error: \(errorMessage)", error)
                                default:
                                    let error = NSError(domain: "", code: -96, userInfo: nil)
                                    reject("ERROR_FOUND", "Video export error.", error)
                                }
                            }
                        }
                    } else {
                        let error = NSError(domain: "", code: -93, userInfo: nil)
                        reject("ERROR_FOUND", "Video export error.", error)
                    }
                }
            })
        }
        //        if mPhasset?.mediaType == .video {
        //
        //            resolve("AssetId: \(mediaId) - qualityVideo: \(qualityVideo) - phFile: \(String(describing: mPhasset))")
        //        } else {
        //            let error = NSError(domain: "", code: -92, userInfo: nil)
        //            reject("ERROR_FOUND", "Can't get media", error)
        //            return;
        //        }
        
        
    }
}
