//
//  TGSDKCordova.m
//  HelloCordova
//
//  Created by 徐恺 on 2017/7/13.
//
//

#import "TGSDKCordova.h"

@implementation TGSDKCordova

@synthesize preloadCallback;
@synthesize adCallback;

- (void) setDebugModel: (CDVInvokedUrlCommand*)command {
    BOOL isDebugModel = [command.arguments objectAtIndex: 0];
    [TGSDK setDebugModel:isDebugModel];
}

- (void) initialize: (CDVInvokedUrlCommand*)command {
    NSString *appid = [command.arguments objectAtIndex: 0];
    NSString *channelid = nil;
    if (command.arguments.count > 1) {
        channelid = [command.arguments objectAtIndex: 1];
    }
    [TGSDK initialize:appid channelID:channelid callback:^(BOOL success, id  _Nullable tag, NSDictionary * _Nullable result) {
        CDVPluginResult* pluginResult = nil;
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) setSDKConfig: (CDVInvokedUrlCommand*)command {
    NSString *k = [command.arguments objectAtIndex: 0];
    NSString *v = [command.arguments objectAtIndex: 1];
    [TGSDK setSDKConfig:v forKey:k];
}

- (void) getSDKConfig: (CDVInvokedUrlCommand*)command {
    NSString *k = [command.arguments objectAtIndex: 0];
    [TGSDK getSDKConfig:k];
}

- (void) preload: (CDVInvokedUrlCommand*)command {
    preloadCallback = command.callbackId;
    [TGSDK preloadAd:self];
}

- (void) couldShowAd: (CDVInvokedUrlCommand*)command {
    NSString *scene = [command.arguments objectAtIndex: 0];
    CDVPluginResult* pluginResult = nil;
    if ([TGSDK couldShowAd:scene]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) showAd: (CDVInvokedUrlCommand*)command {
    adCallback = command.callbackId;
    [TGSDK setADDelegate:self];
    [TGSDK setRewardVideoADDelegate:self];
    NSString *scene = [command.arguments objectAtIndex: 0];
    [TGSDK showAd:scene];
}

- (void) showTestView: (CDVInvokedUrlCommand*)command {
    [TGSDK setADDelegate:self];
    [TGSDK setRewardVideoADDelegate:self];
    NSString *scene = [command.arguments objectAtIndex: 0];
    [TGSDK showTestView:scene];
}

- (void) onPreloadSuccess:(NSString* _Nullable)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onPreloadSuccess", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.preloadCallback];
}

- (void) onPreloadFailed:(NSString* _Nullable)result WithError:(NSError* _Nullable) error {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:[NSArray arrayWithObjects: @"onPreloadFailed", result, error, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.preloadCallback];
}

- (void) onCPADLoaded:(NSString* _Nonnull) result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onCPADLoaded", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.preloadCallback];
}

- (void) onVideoADLoaded:(NSString* _Nonnull) result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onVideoADLoaded", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.preloadCallback];
}

- (void) onShowSuccess:(NSString* _Nonnull)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onShowSuccess", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onShowFailed:(NSString* _Nonnull)result WithError:(NSError* _Nullable)error {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:[NSArray arrayWithObjects: @"onShowFailed", result, error, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onADComplete:(NSString* _Nonnull)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onADComplete", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onADClick:(NSString* _Nonnull)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onADClick", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onADClose:(NSString* _Nonnull)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onADClose", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onADAwardSuccess:(NSString* _Nonnull)result {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:[NSArray arrayWithObjects: @"onADAwardSuccess", result, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

- (void) onADAwardFailed:(NSString* _Nonnull)result WithError:(NSError* _Nullable)error {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:[NSArray arrayWithObjects: @"onADAwardFailed", result, error, nil]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.adCallback];
}

@end
