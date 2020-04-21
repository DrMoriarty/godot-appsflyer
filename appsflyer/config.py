def can_build(env, platform):
    #if platform == "android":
    #    return True
    if platform == "iphone":
	return True
    return False

def configure(env):
    #if (env['platform'] == 'android'):
    #    env.android_add_dependency("implementation 'com.appsflyer:af-android-sdk:4+@aar'")
    #    env.android_add_dependency("implementation 'com.android.installreferrer:installreferrer:1.0'")
    #    env.android_add_to_permissions("android/AndroidManifestPermissionsChunk.xml")
    #    env.android_add_to_manifest("android/AndroidManifestChunk.xml")
    #    env.android_add_java_dir("android/src/")
    #    env.android_add_res_dir("android/res/")
    #    #env.disable_module()
    if (env['platform'] == 'iphone'):
	pass
