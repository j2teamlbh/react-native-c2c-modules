@objc(C2CModules)
class C2CModules: NSObject {
    
    private func convertToId(url: String) -> String {
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
    
    private func getQualityOfVideo(presetName: String) -> String {
        if presetName == "low" {
            return AVAssetExportPresetLowQuality
        }else if presetName == "medium" {
            return AVAssetExportPresetMediumQuality
        }else if presetName == "high" {
            return AVAssetExportPresetHighestQuality
        }else {
            return AVAssetExportPresetPassthrough
        }
    }
    
    private func exportVideo(key:String, inputurl: URL, presetName: String, outputFileType: AVFileType = .mp4, fileExtension: String = "mp4", then completion: @escaping (URL?) -> Void) {
        var outputURL:URL!
        let asset = AVAsset(url: inputurl)
        if #available(iOS 10.0, *) {
            outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(key)
            if let session = AVAssetExportSession(asset: asset, presetName: presetName) {
                session.outputURL = outputURL
                session.outputFileType = outputFileType
                session.shouldOptimizeForNetworkUse = true
                session.exportAsynchronously {
                    switch session.status {
                    case .completed:
                        completion(outputURL)
                    case .cancelled:
                        completion(nil)
                    case .failed:
                        completion(nil)
                    default:
                        break
                    }
                }
            }else {
                completion(nil)
            }
        }else {
            completion(nil)
        }
    }
    
    private func getURL(ofMediaWith mPhasset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?, _ mediaType: String) -> Void)) {
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL, "image")
            })
        } else if mPhasset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: mPhasset, options: options, resultHandler: { (asset, audioMix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl, "video")
                } else {
                    completionHandler(nil, "")
                }
            })
        }
    }
    
    @objc(convertPHAsset:withResolver:withRejecter:)
    func convertPHAsset(params: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
        if #available(iOS 10.0, *) {} else {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            reject("ERROR_FOUND", "This function is only available in iOS 10.0 or newer", error)
            return;
        }
        let phAssetParams:String = RCTConvert.nsString(params["id"])
        let qualityParams:String = RCTConvert.nsString(params["quality"]) ?? "original"
        let presetName:String = getQualityOfVideo(presetName: qualityParams)
        let mediaId = convertToId(url: phAssetParams)
        if mediaId.count < 36 {
            let error = NSError(domain: "", code: -2, userInfo: nil)
            reject("ERROR_FOUND", "Invalid URL", error)
            return;
        }
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [mediaId], options: nil)
        if let mPhasset = fetchResult.firstObject {
            getURL(ofMediaWith: mPhasset, completionHandler: {(url: URL?, mediaType: String) -> Void in
                if let originalUrl = url {
                    let fileName = UUID().uuidString
                    if mediaType == "video" {
                        self.exportVideo(key: "\(fileName).mp4", inputurl: originalUrl, presetName: presetName) { (successData) in
                            if let convertedUrl = successData {
                                let convertedUrlStr: String = convertedUrl.absoluteString
                                let dataResult: NSMutableDictionary = [:]
                                dataResult["type"] = "video"
                                dataResult["filename"] = "\(fileName).mp4"
                                dataResult["path"] = convertedUrlStr
                                dataResult["mimeType"] = "video/mp4"
                                resolve(dataResult)
                            }
                        }
                    } else {
                        let error = NSError(domain: "", code: -3, userInfo: nil)
                        reject("ERROR_FOUND", "File not supported", error)
                        return;
                    }
                } else {
                    let error = NSError(domain: "", code: -3, userInfo: nil)
                    reject("ERROR_FOUND", "File not supported", error)
                    return;
                }
            })
        }
    }
}
