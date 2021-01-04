extends Node

static func process(features: PoolStringArray, debug: bool, path: String, flags: int) -> void:
    if 'Android' in features:
        pass
    if 'iOS' in features:
        add_ios_framework('AdSupport.framework')
        add_ios_framework('iAd.framework')
