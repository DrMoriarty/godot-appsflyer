extends Node

var _i = null
var _cached_appsflyer_id = null
onready var _localnotification := $'/root/localnotification'

func _ready():
    if Engine.has_singleton("AppsFlyer"):
        _i = Engine.get_singleton("AppsFlyer")
    elif type_exists('AppsFlyer'):
        _i = ClassDB.instance('AppsFlyer')
    elif OS.get_name() == 'iOS':
        _i = load("res://addons/bin/appsflyer.gdns").new()
    else:
        push_warning('AppsFlyer plugin not found!')
    var app_key = null
    var app_id = null
    if ProjectSettings.has_setting('AppsFlyer/DevKey'):
        app_key = ProjectSettings.get_setting('AppsFlyer/DevKey')
    if ProjectSettings.has_setting('AppsFlyer/APP_ID'):
        app_id = ProjectSettings.get_setting('AppsFlyer/APP_ID')
    if app_key == null:
        push_warning('You need to init AppsFlyer with app_key before using')
    elif app_key != null and app_id != null and app_id != '':
        init_with_id(app_key, app_id)
    else:
        init(app_key)
    if _localnotification != null:
        _localnotification.connect('device_token_received', self, '_on_device_token_received')

func init(app_key: String) -> void:
    if _i != null:
        var production = !OS.is_debug_build()
        print('AppsFlyer plugin inited with key')
        _i.init(app_key, production)

func init_with_id(app_key: String, app_id: String) -> void:
    if _i != null:
        print('AppsFlyer plugin inited with key and app id')
        _i.init(app_key, app_id)

func screen(name: String, screen_type: String) -> void:
    _track_event('af_content_view', {'af_content': name, 'af_content_type': screen_type})

func level_start(params: Dictionary) -> void:
    _track_event('level_start', {'af_level': params.level, 'stage': params.stage})

func level_complete(params: Dictionary) -> void:
    _track_event('af_level_achieved', {'af_level': params.level, 'stage': params.stage, 'stars': params.stars, 'af_score': params.score, 'time': params.time, 'af_success': true, 'continue': params.continue, 'challenge': params.challenge})

func level_failed(params: Dictionary) -> void:
    _track_event('level_failed', {'af_level': params.level, 'stage': params.stage, 'continue': params['continue'], 'time': params.time, 'completion': params.completion})

func level_really_failed(params: Dictionary) -> void:
    _track_event('level_really_failed', {'af_level': params.level, 'stage': params.stage, 'continue': params['continue'], 'time': params.time, 'completion': params.completion})

func login(params: Dictionary) -> void:
    _track_event('af_login', {'af_registration_method': params.method, 'af_success': params.success})

func event(name: String, params: Dictionary) -> void:
    _track_event(name, params)

func appsflyer_id() -> String:
    if _cached_appsflyer_id != null:
        return _cached_appsflyer_id
    if _i != null:
        _cached_appsflyer_id = _i.appsflyer_id()
        return _cached_appsflyer_id
    else:
        return ''

#
# Internal methods
#

func _track_event(event: String, params := {}) -> void:
    if params == null:
        params = {}
    if _i != null:
        _i.track_event(event, params)

func _on_device_token_received(token: String) -> void:
    if _i != null:
        _i.set_uninstall_token(token)
