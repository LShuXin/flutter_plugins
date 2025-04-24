# flutter_restart_plus
A Flutter plugin for restarting Android and iOS applications.

## Overview

**Android**
The plugin uses the following approach to restart the app:
```kotlin
val intent = context.packageManager?.getLaunchIntentForPackage(context.packageName)
intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
intent?.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
activity.startActivity(intent)
```

**IOS**
The plugin sends a local notification and exits the app. The user can manually tap the notification to restart the app.
**Note**: For iOS, you must request local notification permissions before calling the restart method.

## Installation
Add flutter_restart_plus to your project's dependencies:

```
dependencies:
  flutter_restart_plus: ^0.0.1
```

## Usage
To restart the app in Flutter, use the following code:

```dart
import 'package:flutter_restart_plus/flutter_restart_plus.dart';

Future<void> restartApp() async {
    await FlutterRestartPlus().restartApp();
}
```
**iOS-Specific Instructions**
On iOS, you must request local notification permissions before calling the restart method. Here’s a basic implementation in the iOS native layer:

```swift
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
      if response.notification.request.identifier == "restartNotification" {
          // xxx
      }
      completionHandler()
  }
}
```

## Notes
- **Android**: No additional setup is required in the native layer.
- **iOS**: Ensure the app has notification permissions before calling the restart method, as the app restart depends on user interaction with the notification.
- **Permissions**: Requesting notification permissions is mandatory for iOS functionality.

## License
This project is licensed under the MIT License.

For any issues or feature requests, feel free to open an issue or submit a pull request on the GitHub [repository](https://github.com/LShuXin/flutter_restart_plus).