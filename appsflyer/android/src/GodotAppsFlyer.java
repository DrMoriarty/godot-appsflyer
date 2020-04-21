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
import com.appsflyer.AppsFlyerInAppPurchaseValidatorListener;
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
                "track_event",
                "track_revenue",
                "appsflyer_id"
            });
        activity = (Godot)p_activity;
    }

    // Public methods

    public void init(final String key)
    {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    AppsFlyerConversionListener conversionDataListener = new AppsFlyerConversionListener() {
                            /* Returns the attribution data. Note - the same conversion data is returned every time per install */
                            @Override
                            public void onConversionDataSuccess(Map<String, Object> conversionData) {
                                for (String attrName : conversionData.keySet()) {
                                    Log.d("godot", "[AppsFlyer] Attribute: " + attrName + " = " + conversionData.get(attrName));
                                }
                            }
                            @Override
                            public void onConversionDataFail(String errorMessage) {
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
                    AppsFlyerLib.getInstance().
                        registerValidatorListener(activity,
                                                  new AppsFlyerInAppPurchaseValidatorListener() {
                                                      public void onValidateInApp() {
                                                          Log.d("godot", "[AppsFlyer] Purchase validated successfully");
                                                      }
                                                      public void onValidateInAppFailure(String error) {
                                                          Log.d("godot", "[AppsFlyer] onValidateInAppFailure called: " + error);
                                                      }
                                                  });
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

    public void set_uninstall_token(final String token)
    {
    }

    public void track_revenue(final String revenue, final String currency, final String signature, final String originalJson, final String public_key)
    {
        AppsFlyerLib.getInstance().validateAndTrackInAppPurchase(activity, public_key, signature, originalJson, revenue, currency, null);
    }

    public String appsflyer_id()
    {
        return AppsFlyerLib.getInstance().getAppsFlyerUID(activity);
    }

    // Internal methods

    @Override protected void onMainActivityResult (int requestCode, int resultCode, Intent data)
    {
    }
}
