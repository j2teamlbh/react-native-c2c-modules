#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(C2CModules, NSObject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXTERN_METHOD(convertPHAsset:(NSDictionary *)params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(showLimitedLibrary)

RCT_EXTERN_METHOD(checkPhotoLibrary:(RCTResponseSenderBlock)callback)

@end
