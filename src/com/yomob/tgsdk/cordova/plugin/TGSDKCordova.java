package com.yomob.tgsdk.cordova.plugin;

import java.util.Map;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.soulgame.sgsdk.tgsdklib.TGSDK;
import com.soulgame.sgsdk.tgsdklib.TGSDKServiceResultCallBack;
import com.soulgame.sgsdk.tgsdklib.ad.ITGADListener;
import com.soulgame.sgsdk.tgsdklib.ad.ITGADMonitorListener;
import com.soulgame.sgsdk.tgsdklib.ad.ITGPreloadListener;
import com.soulgame.sgsdk.tgsdklib.ad.ITGRewardVideoADListener;

public class TGSDKCordova extends CordovaPlugin implements ITGPreloadListener, ITGADListener, ITGRewardVideoADListener {

    private CallbackContext preloadCallbackContext;
    private CallbackContext adCallbackContext;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals("setDebugModel")) {
            boolean isDebugModel = args.getBoolean(0);
            TGSDK.setDebugModel(isDebugModel);
            callbackContext.success();
        } else if (action.equals("setSDKConfig")) {
            String k = args.getString(0);
            String v = args.getString(1);
            TGSDK.setSDKConfig(k, v);
            callbackContext.success();
        } else if (action.equals("getSDKConfig")) {
            String k = args.getString(0);
            callbackContext.success(TGSDK.getSDKConfig(k));
        } else if (action.equals("initialize")) {
            String appid = args.getString(0);
            String channelid = null;
            if (args.length() > 1) {
                channelid = args.getString(1);
            }
            TGSDK.initialize(this.cordova.getActivity(), appid, channelid, new TGSDKServiceResultCallBack(){

                @Override
                public void onFailure(Object tag, final String error) {
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            callbackContext.error(error);
                        }
                    });
                }

                @Override
                public void onSuccess(Object arg0, Map<String, String> arg1) {
                    cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            callbackContext.success();
                        }
                    });
                }

            });
        } else if (action.equals("preload")) {
            preloadCallbackContext = callbackContext;
            TGSDK.preloadAd(this.cordova.getActivity(), this);
        } else if (action.equals("couldShowAd")) {
            String scene = args.getString(0);
            if (TGSDK.couldShowAd(scene)) {
                callbackContext.success(scene);
            } else {
                callbackContext.error(scene);
            }
        } else if (action.equals("showAd")) {
            adCallbackContext = callbackContext;
            TGSDK.setADListener(this);
            TGSDK.setRewardVideoADListener(this);
            String scene = args.getString(0);
            TGSDK.showAd(this.cordova.getActivity(), scene);
        } else if (action.equals("showTestView")) {
            String scene = args.getString(0);
            TGSDK.showTestView(this.cordova.getActivity(), scene);
            callbackContext.success();
        } else {
            return false;
        }
        return true;
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        TGSDK.onPause(this.cordova.getActivity());
    }


    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        TGSDK.onResume(this.cordova.getActivity());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        TGSDK.onDestroy(this.cordova.getActivity());
    }

    private void callback(CallbackContext cxt, String evt, String ret) {
        JSONArray ja = new JSONArray();
        ja.put(evt);
        ja.put(ret);
        PluginResult pr = new PluginResult(PluginResult.Status.OK, ja);
        pr.setKeepCallback(true);
		cxt.sendPluginResult(pr);
    }

    @Override
    public void onPreloadSuccess(final String result) {
        if (null != preloadCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(preloadCallbackContext, "onPreloadSuccess", result);
                }
            });
        }
    }

    @Override
    public void onPreloadFailed(final String scene, final String error) {
        if (null != preloadCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(preloadCallbackContext, "onPreloadFailed", error);
                }
            });
        }
    }

    @Override
    public void onCPADLoaded(final String result) {
        if (null != preloadCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(preloadCallbackContext, "onCPADLoaded", result);
                }
            });
        }
    }

    @Override
    public void onVideoADLoaded(final String result) {
        if (null != preloadCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(preloadCallbackContext, "onVideoADLoaded", result);
                }
            });
        }
    }

    @Override
    public void onShowSuccess(final String arg0) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onShowSuccess", arg0);
                }
            });
        }
    }

    @Override
    public void onShowFailed(final String ad, final String err) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onShowFailed", err);
                }
            });
        }
    }

    @Override
    public void onADComplete(final String arg0) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onADComplete", arg0);
                }
            });
        }
    }

    @Override
    public void onADClose(final String arg0) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onADClose", arg0);
                }
            });
        }
    }

    @Override
    public void onADClick(final String arg0) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onADClick", arg0);
                }
            });
        }
    }

    @Override
    public void onADAwardSuccess(final String arg0) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onADAwardSuccess", arg0);
                }
            });
        }
    }

    @Override
    public void onADAwardFailed(final String arg0, final String arg1) {
        if (null != adCallbackContext) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    callback(adCallbackContext, "onADAwardFailed", arg0);
                }
            });
        }
    }
    
}

