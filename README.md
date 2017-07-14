Cordova TGSDK plugin
====================
# Overview #
Show TGSDK rewarded video ad

Requires YoMob account https://www.yomob.com/

TGSDK 1.6.7

This is open source cordova plugin.

# Change log #
```c
2017.7.14 Version 1.6.7
```
# Install plugin #

## Cordova cli ##
```c
cordova plugin add cordova-plugin-tgsdk
(when build error, use github url: cordova plugin add https://github.com/soulgame/cordova-plugin-tgsdk)
```
# API #

###Initialize TGSDK

After registering account and creating your App on [Yomob Official Website](http://yomob.com/) you will acquire the corresponding product `AppID` from the website, and then use this parameter to initialize TGSDK.

```javascript
window.tgsdk.initialize("Your AppID from Yomob");
```

###Enable Debug mode

After enabling Debug mode, you can view the output of much more logs. This is convenient for locating problems.

>Note: **Do not use Debug mode under production environment. In addition, if it is necessary to enable Debug mode, set Debug mode enabled before calling the initialization API.**

```javascript
window.tgsdk.setDebugModel(true);
```
###Preload Ads Resources

To have enough time to load ads resources, it is recommended to call the preload API to load ads as early as possible. You can even call the preload API to load ads as soon as you initialize TGSDK.

```javascript
window.tgsdk.preload();
```
###Set monitoring on ads preload event

You can monitor the ads loading process via `function`.

```javascript
window.tgsdk.onPreloadSuccess = function(ret) {
    // Ads preload calling succeeds
};
window.tgsdk.onPreloadFailed = function(ret) {
    // Ads preload calling fails
};
window.tgsdk.onCPADLoaded = function(ret) {
    // Static interstitial ads are ready
};
window.tgsdk.onVideoADLoaded = function(ret) {
    // Video ads are ready
};
```
###Play Ads

First, please create ad scenes for the registered App via [Yomob Official Website](http://yomob.com/). After acquiring the corresponding ad scene ID, you can use it to verify whether the ads are ready. If the ads of the corresponding scene are ready, the video ads play API can be called to play the ads.

```javascript
window.tgsdk.couldShowAd(
    "Your scene id from Yomob",
    function(){
        window.tgsdk.showAd("Your scene id from Yomob");
    },
    function() {
        console.log("[cordova] not ready");
    }
);
```
###Set monitoring on ads playing behavior event

Monitor events occurred during ads playing process via `function`.

```javascript
window.tgsdk.onADAwardSuccess = function(ret) {
    //  If the rewarded video ads conditions are satisfied, the users can be awarded the bonus
};
window.tgsdk.onADAwardFailed = function(ret) {
    //  If the rewarded video ads conditions are not satisfied, the users cannot be awarded the bonus
};
window.tgsdk.onShowSuccess = function(ret) {
    // Ads start to play
};
window.tgsdk.onShowFailed = function(ret) {
    // Ads fail to play
};
window.tgsdk.onADComplete = function(ret) {
    // Ads playing ends
};
window.tgsdk.onADClick = function(ret) {
    // After a user clicks ads, the ads playing page skips to other pages
};
window.tgsdk.onADClose = function(ret) {
    // Ads are closed
};
```
###Ads Test Tool

>**Please do not use this function in prodction enviornment. It is only for testing**

During test phase, you can use APIs provided by Ads Test Tool instead of original ads API to better test your in App ads view logic.

Use Ads Test Tool API

```javascript
window.tgsdk.showTestView("Your scene id from Yomob");
```

Instead of useing original API

```javascript
window.tgsdk.showAd("Your scene id from Yomob");
```
# Example #

example for index.js

```javascript
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);

        console.log("TGSDK cordova start...");
        window.tgsdk.setDebugModel(true);
        window.tgsdk.initialize("59t5rJH783hEQ3Jd7Zqr");
        window.isAdShowing = false;
        window.isAdReady = false;
        window.tgsdk.onVideoADLoaded = function(ret) {
            console.log("[cordova] onVideoADLoaded "+ret);
            window.tgsdk.couldShowAd(
                "hiRZYZxDI7c2LaOgrE7",
                function(){
                    window.isAdReady = true;
                    setTimeout(function(){
                        if (!window.isAdShowing) {
                            window.isAdShowing = true;
                            window.tgsdk.showAd("hiRZYZxDI7c2LaOgrE7");
                        }
                    }, 500);
                },
                function() {
                    console.log("[cordova] hiRZYZxDI7c2LaOgrE7 not ready");
                }
            );
        };
        window.tgsdk.onShowSuccess = function() {
            window.isAdShowing = true;
        };
        window.tgsdk.onShowFailed = function() {
            window.isAdShowing = false;
        };
        window.tgsdk.onADClose = function(ret) {
            window.isAdShowing = false;
            setTimeout(function(){
                if (!window.isAdShowing && window.isAdReady) {
                    window.tgsdk.showAd("hiRZYZxDI7c2LaOgrE7");
                }
            }, 500);
        };
        window.tgsdk.preload();
    }
};

app.initialize();
```
