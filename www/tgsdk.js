module.exports = {
    setDebugModel: function(debug) {
        cordova.exec(null, null, 'TGSDKCordova', 'setDebugModel', [debug]);
    },
    initialize: function(appid, channelid) {
        console.log("[cordova] TGSDK.initialize");
        var self = this;
        cordova.exec(
            function(){
                console.log("[cordova] onInitSuccess");
                if (!!window.Event && !!window.document) {
                    var evt = new Event('onInitSuccess');
                    window.document.dispatchEvent(evt);
                }
                if (self.onInitSuccess) {
                    self.onInitSuccess();
                }
            },
            function(err) {
                console.log("[cordova] onInitFailure("+err+")");
                if (!!window.CustomEvent && !!window.document) {
                    var evt = new CustomEvent('onInitFailure', {'error' : err});
                    window.document.dispatchEvent(evt);
                }
                if (self.onInitFailure) {
                    self.onInitFailure(err);
                }
            },
            'TGSDKCordova', 'initialize',
            [appid, channelid]
        );
    },
    setSDKConfig: function(k, v) {
        console.log("[cordova] TGSDK.setSDKConfig("+k+", "+v+")");
        var self = this;
        cordova.exec(
            null, null, 'TGSDKCordova', 'setSDKConfig', [k, v]
        );
    },
    getSDKConfig: function(k, cb) {
        console.log("[cordova] TGSDK.getSDKConfig("+k+")");
        var self = this;
        cordova.exec(
            cb, null, 'TGSDKCordova', 'getSDKConfig', [k]
        );
    },
    getSceneParameter: function(scene, key, gotFunc, notGetFunc) {
        console.log("[cordova] TGSDK.parameterFromAdScene("+scene+", "+key+")");
        var self = this;
        cordova.exec(
            gotFunc,
            notGetFunc,
            'TGSDKCordova', 'getSceneParameter', [scene, key]
        );
    },
    preload: function() {
        console.log("[cordova] TGSDK.preload");
        var self = this;
        cordova.exec(
            function(msg) {
                if (!!msg) {
                    var evt = msg[0];
                    var ret = msg[1];
                    console.log("[cordova] TGSDK "+evt+"("+ret+")");
                    if (!!window.CustomEvent && !!window.document) {
                        var cevt = new CustomEvent(evt, {'result' : ret});
                        window.document.dispatchEvent(cevt);
                    }
                    if (self[evt]) {
                        self[evt](ret);
                    }
                }
            },
            null, 'TGSDKCordova', 'preload', []
        );
    },
    couldShowAd: function(scene, isReadyFunc, notReadyFunc) {
        console.log("[cordova] TGSDK.couldShowAd("+scene+")");
        var self = this;
        cordova.exec(
            isReadyFunc, notReadyFunc, 'TGSDKCordova', 'couldShowAd', [scene]
        );
    },
    showAd: function(scene) {
        console.log("[cordova] TGSDK.showAd("+scene+")");
        var self = this;
        cordova.exec(
            function(msg) {
                if (!!msg) {
                    var evt = msg[0];
                    var ret = msg[1];
                    console.log("[cordova] TGSDK "+evt+"("+ret+")");
                    if (!!window.CustomEvent && !!window.document) {
                        var cevt = new CustomEvent(evt, {'result' : ret});
                        window.document.dispatchEvent(cevt);
                    }
                    if (self[evt]) {
                        self[evt](ret);
                    }
                }
            },
            null, 'TGSDKCordova', 'showAd', [scene]
        );
    },
    showTestView: function(scene) {
        console.log("[cordova] TGSDK.showTestView("+scene+")");
        var self = this;
        cordova.exec(
            function(msg) {
                if (!!msg) {
                    var evt = msg[0];
                    var ret = msg[1];
                    console.log("[cordova] TGSDK "+evt+"("+ret+")");
                    if (!!window.CustomEvent && !!window.document) {
                        var cevt = new CustomEvent(evt, {'result' : ret});
                        window.document.dispatchEvent(cevt);
                    }
                    if (self[evt]) {
                        self[evt](ret);
                    }
                }
            },
            null, 'TGSDKCordova', 'showTestView', [scene]
        );
    }
};
