#include <Godot.hpp>
#include "AppsFlyer.hpp"

extern "C" void GDN_EXPORT appsflyer_gdnative_init(godot_gdnative_init_options *o)
{
	godot::Godot::gdnative_init(o);
}

extern "C" void GDN_EXPORT appsflyer_gdnative_terminate(godot_gdnative_terminate_options *o)
{
	godot::Godot::gdnative_terminate(o);
}

extern "C" void GDN_EXPORT appsflyer_nativescript_init(void *handle)
{
	godot::Godot::nativescript_init(handle);


	godot::register_class<AppsFlyer>();
}

extern "C" void GDN_EXPORT appsflyer_gdnative_singleton()
{
}
