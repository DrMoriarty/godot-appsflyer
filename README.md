# AppsFlyer plugin for Godot Engine (iOS/Android)

## Installation

1. At first you need [NativeLib-CLI](https://github.com/DrMoriarty/nativelib-cli) or [NativeLib Addon](https://github.com/DrMoriarty/nativelib).

2. Make `nativelib -i appsflyer` in your project directory if you are using CLI. Find `APPSFLYER` in plugins list and press "Install" button if you are using GUI Addon.

3. Add `AppsFlyer/DevKey` in your Project Settings.

4. Enable **Custom Build** for using in Android.

## Usage

Add wrapper `scripts/appsflyer.gd` into autoloading list in your project. So you can use it everywhere in your code.

## API

### init(app_key: String)

You should not use it directly. It will be called automatically when your application starts.

### appsflyer_id() -> String

You can get appsflyer user ID with this method.

### event(name: String, params: Dictionary)

The main method for sending analytics events. All other public methods are shortcuts for specific event and uses `event` internaly.

### screen(name: String, screen_type: String)

Event when user opens specific screen.

### login(params: Dictionary)

Event when user registered or logged into your app.

### level_start(params: Dictionary)

### level_complete(params: Dictionary)

### level_failed(params: Dictionary)
