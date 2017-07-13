module.exports = {
    setDebugModel: function(debug) {
        cordova.exec(null, null, 'TGSDK', 'setDebugModel', [debug]);
    },
    initialize: function(appid, channelid) {
        console.log("[cordova] TGSDK.initialize");
        var self = this;
        cordova.exec(
            function(){
                console.log("[cordova] onInitSuccess");
                if (self.onInitSuccess) {
                    self.onInitSuccess();
                }
            },
            function(err) {
                console.log("[cordova] onInitFailure("+err+")");
                if (self.onInitFailure) {
                    self.onInitFailure(err);
                }
            },
            'TGSDK', 'initialize',
            [appid, channelid]
        );
    },
    setSDKConfig: function(k, v) {
        console.log("[cordova] TGSDK.setSDKConfig("+k+", "+v+")");
        var self = this;
        cordova.exec(
            null, null, 'TGSDK', 'setSDKConfig', [k, v]
        );
    },
    getSDKConfig: function(k, cb) {
        console.log("[cordova] TGSDK.getSDKConfig("+k+")");
        var self = this;
        cordova.exec(
            cb, null, 'TGSDK', 'getSDKConfig', [k]
        );
    },
    preload: function() {
        console.log("[cordova] TGSDK.preload");
        var self = this;
        cordova.exec(
            function(evt, ret) {
                console.log("[cordova] TGSDK "+evt+"("+ret+")");
                if (self[evt]) {
                    self[evt](ret);
                }
            },
            null, 'TGSDK', 'preload', []
        );
    },
    couldShowAd: function(scene, isReadyFunc, notReadyFunc) {
        console.log("[cordova] TGSDK.couldShowAd("+scene+")");
        var self = this;
        cordova.exec(
            isReadyFunc, notReadyFunc, 'TGSDK', 'couldShowAd', [scene]
        );
    },
    showAd: function(scene) {
        console.log("[cordova] TGSDK.showAd("+scene+")");
        var self = this;
        cordova.exec(
            function(evt, ret) {
                console.log("[cordova] TGSDK "+evt+"("+ret+")");
                if (self[evt]) {
                    self[evt](ret);
                }
            },
            null, 'TGSDK', 'showAd', [scene]
        );
    }
};
