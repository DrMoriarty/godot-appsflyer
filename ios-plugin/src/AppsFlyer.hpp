//
//  GodotAppsFlyer.h
//
//  Created by Vasiliy on 13.05.19.
//
//

#ifndef GodotAppsFlyer_h
#define GodotAppsFlyer_h

#include <Godot.hpp>
#include <Object.hpp>

class AppsFlyer : public godot::Object {
    GODOT_CLASS(AppsFlyer, godot::Object);

public:
    AppsFlyer();
    ~AppsFlyer();

    static void _register_methods();
    void _init();

    void init(const godot::String key, const godot::String appId);
    void trackEvent(const godot::String event, const godot::Dictionary params);
    void setUninstallToken(const godot::String token);
    godot::String appsFlyerId();

};

#endif /* GodotAppsFlyer_h */
