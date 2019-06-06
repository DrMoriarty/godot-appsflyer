//
//  GodotAppsFlyer.h
//
//  Created by Vasiliy on 13.05.19.
//
//

#ifndef GodotAppsFlyer_h
#define GodotAppsFlyer_h

#include "core/object.h"

class GodotAppsFlyer : public Object {
    GDCLASS(GodotAppsFlyer, Object);

    static void _bind_methods();

public:
    GodotAppsFlyer();
    ~GodotAppsFlyer();

    void init(const String& key, const String& appId);
    void trackEvent(const String& event, const Dictionary& params);
    void setUninstallToken(const String& token);

};

#endif /* GodotAppsFlyer_h */
