#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(C2CModules, NSObject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXTERN_METHOD(convertPHAsset:(NSDictionary *)params
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

@end
