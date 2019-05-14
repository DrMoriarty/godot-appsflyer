package org.godotengine.godot;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.util.Log;
import android.os.Bundle;
import java.util.Map;
import java.util.List;
import java.util.Arrays;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerConversionListener;
import com.godot.game.BuildConfig;

public class GodotAppsFlyer extends Godot.SingletonBase {

    private Godot activity = null;

    static public Godot.SingletonBase initialize(Activity p_activity) 
    { 
        return new GodotAppsFlyer(p_activity); 
    } 

    public GodotAppsFlyer(Activity p_activity) 
    {
        registerClass("GodotAppsFlyer", new String[]{
                "init",
                "track_event"
            });
        activity = (Godot)p_activity;
    }

    // Public methods

    public void init(final String key, final String appId /* not used, placed for compatibility with iOS API */)
    {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    AppsFlyerConversionListener conversionDataListener = new AppsFlyerConversionListener() {
                            /* Returns the attribution data. Note - the same conversion data is returned every time per install */
                            @Override
                            public void onInstallConversionDataLoaded(Map<String, String> conversionData) {
                                for (String attrName : conversionData.keySet()) {
                                    Log.d("godot", "[AppsFlyer] Attribute: " + attrName + " = " + conversionData.get(attrName));
                                }
                            }
                            @Override
                            public void onInstallConversionFailure(String errorMessage) {
                                Log.e("godot", "[AppsFlyer] Error getting conversion data: " + errorMessage);
                            }
                            /* Called only when a Deep Link is opened */
                            @Override
                            public void onAppOpenAttribution(Map<String, String> conversionData) {
                                for (String attrName : conversionData.keySet()) {
                                    Log.d("godot", "[AppsFlyer] Attribute: " + attrName + " = " + conversionData.get(attrName));
                                }
                            }
                            @Override
                            public void onAttributionFailure(String errorMessage) {
                                Log.e("godot", "[AppsFlyer] Error onAttributionFailure : " + errorMessage);
                            }
                        };
                    AppsFlyerLib.getInstance().init(key, conversionDataListener, activity.getApplicationContext());
                    AppsFlyerLib.getInstance().startTracking(activity.getApplication());
                    if(BuildConfig.DEBUG) {
                        AppsFlyerLib.getInstance().setDebugLog(true);
                    }
                } catch (Exception e) {
                    Log.e("godot", "Failed to initialize AppsFlyerSdk: " + e.getMessage()); 
                }
            }
        });
    }
    
    public void track_event(final String event, final Dictionary params)
    {
        AppsFlyerLib.getInstance().trackEvent(activity, event, params);
    }

    // Internal methods

    @Override protected void onMainActivityResult (int requestCode, int resultCode, Intent data)
    {
    }
}
