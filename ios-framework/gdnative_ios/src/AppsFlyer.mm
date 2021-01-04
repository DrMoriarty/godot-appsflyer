//
//  GodotKochava.mm
//
//  Created by Vasiliy on 13.05.19.
//
//

#import <Foundation/Foundation.h>
#import "AppsFlyer.hpp"
#import <AppsFlyerLib/AppsFlyerLib.h>

using namespace godot;

NSDictionary *convertFromDictionary(const Dictionary& dict)
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for(int i=0; i<dict.keys().size(); i++) {
        Variant key = dict.keys()[i];
        Variant val = dict[key];
        if(key.get_type() == Variant::STRING) {
            String skey = key;
            NSString *strKey = [NSString stringWithUTF8String:skey.utf8().get_data()];
            if(val.get_type() == Variant::INT) {
                int i = (int)val;
                result[strKey] = @(i);
            } else if(val.get_type() == Variant::REAL) {
                double d = (double)val;
                result[strKey] = @(d);
            } else if(val.get_type() == Variant::STRING) {
                String sval = val;
                NSString *s = [NSString stringWithUTF8String:sval.utf8().get_data()];
                result[strKey] = s;
            } else if(val.get_type() == Variant::BOOL) {
                BOOL b = (bool)val;
                result[strKey] = @(b);
            } else if(val.get_type() == Variant::DICTIONARY) {
                NSDictionary *d = convertFromDictionary((Dictionary)val);
                result[strKey] = d;
            } else {
                ERR_PRINT("Unexpected type as dictionary value");
            }
        } else {
            ERR_PRINT("Non string key in Dictionary");
        }
    }
    return result;
}

AppsFlyer::AppsFlyer()
{
}

AppsFlyer::~AppsFlyer()
{
}

void AppsFlyer::_init()
{
}

void AppsFlyer::init(const String key, const String appId)
{
    NSString *strKey = [NSString stringWithUTF8String:key.utf8().get_data()];
    NSString *strAppId = [NSString stringWithUTF8String:appId.utf8().get_data()];
    
    [AppsFlyerLib shared].appsFlyerDevKey = strKey;
    [AppsFlyerLib shared].appleAppID = strAppId;
    [AppsFlyerLib shared].delegate = nil;
#ifdef DEBUG_ENABLED
    [AppsFlyerLib shared].isDebug = YES;
#endif
}

void AppsFlyer::trackEvent(const String event, const Dictionary params)
{
    NSString *eventName = [NSString stringWithUTF8String:event.utf8().get_data()];
    NSDictionary *dict = convertFromDictionary(params);
    NSLog(@"Send AppsFlyer event: %@, %@", eventName, dict);
    [[AppsFlyerLib shared] logEvent:eventName withValues: dict];
}

void AppsFlyer::setUninstallToken(const String token)
{
    NSData *data = [NSData dataWithBytes:token.utf8().get_data() length:token.utf8().length()];
    [[AppsFlyerLib shared] registerUninstall:data];
}

String AppsFlyer::appsFlyerId()
{
    NSString *appsflyerId = [AppsFlyerLib shared].getAppsFlyerUID;
    String result([appsflyerId UTF8String]);
    return result;
}

void AppsFlyer::_register_methods()
{
    register_method("_init", &AppsFlyer::_init);
    register_method("init", &AppsFlyer::init);
    register_method("track_event", &AppsFlyer::trackEvent);
    register_method("set_uninstall_token", &AppsFlyer::setUninstallToken);
    register_method("appsflyer_id", &AppsFlyer::appsFlyerId);
}

