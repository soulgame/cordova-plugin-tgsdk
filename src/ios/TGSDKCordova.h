//
//  TGSDKCordova.h
//  HelloCordova
//
//  Created by 徐恺 on 2017/7/13.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "TGSDK.h"

@interface TGSDKCordova : CDVPlugin <TGPreloadADDelegate, TGADDelegate, TGRewardVideoADDelegate>

@property NSString *preloadCallback;
@property NSString *adCallback;

- (void) setDebugModel: (CDVInvokedUrlCommand*)command;
- (void) initialize: (CDVInvokedUrlCommand*)command;
- (void) setSDKConfig: (CDVInvokedUrlCommand*)command;
- (void) getSDKConfig: (CDVInvokedUrlCommand*)command;
- (void) preload: (CDVInvokedUrlCommand*)command;
- (void) couldShowAd: (CDVInvokedUrlCommand*)command;
- (void) showAd: (CDVInvokedUrlCommand*)command;
- (void) showTestView: (CDVInvokedUrlCommand*)command;

@end
