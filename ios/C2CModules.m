#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(C2CModules, NSObject)

RCT_EXTERN_METHOD(convertPHAsset:(NSDictionary *)params
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

@end
