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
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) initialize: (CDVInvokedUrlCommand*)command {
    NSString *appid = [command.arguments objectAtIndex: 0];
    NSString *channelid = nil;
    if (command.arguments.count > 2) {
        channelid = [command.arguments objectAtIndex: 1];
    }
    NSLog(@"TGSDK.initialize %@, %@", appid, (channelid?channelid:@"nil"));
    if (nil == channelid || [channelid isEqual:[NSNull null]]) {
        [TGSDK initialize:appid callback:^(BOOL success, id  _Nullable tag, NSDictionary * _Nullable result) {
            CDVPluginResult* pluginResult = nil;
            if (success) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
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
}

- (void) setSDKConfig: (CDVInvokedUrlCommand*)command {
    NSString *k = [command.arguments objectAtIndex: 0];
    NSString *v = [command.arguments objectAtIndex: 1];
    [TGSDK setSDKConfig:v forKey:k];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getSDKConfig: (CDVInvokedUrlCommand*)command {
    NSString *k = [command.arguments objectAtIndex: 0];
    NSString* ret = [TGSDK getSDKConfig:k];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ret];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getSceneParameter: (CDVInvokedUrlCommand*)command {
    NSString *s = [command.arguments objectAtIndex: 0];
    NSString *k = [command.arguments objectAtIndex: 1];
    id r = [TGSDK parameterFromAdScene:s WithKey:k];
    if (r) {
        if ([r isKindOfClass:[NSString class]]) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:r];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else if ([r isKindOfClass:[NSNumber class]]) {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[r stringValue]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void) preload: (CDVInvokedUrlCommand*)command {
    preloadCallback = command.callbackId;
    [TGSDK preloadAd:self];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) showTestView: (CDVInvokedUrlCommand*)command {
    adCallback = command.callbackId;
    [TGSDK setADDelegate:self];
    [TGSDK setRewardVideoADDelegate:self];
    NSString *scene = [command.arguments objectAtIndex: 0];
    [TGSDK showTestView:scene];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
