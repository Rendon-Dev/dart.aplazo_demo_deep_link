# Deep Link Demo App

This Flutter application demonstrates how to handle deep links and display all query parameters when a deep link opens the app.

## Features

- **Deep Link Detection**: Automatically detects when the app is opened via a deep link
- **Parameter Display**: Shows all query parameters from the deep link as a list of "name: value" pairs
- **Real-time Updates**: Handles deep links both when the app is launched and when it's already running
- **Testing Tools**: Built-in test buttons to simulate different deep link scenarios
- **URL Testing**: Tools to test opening URLs in external apps or WebView

## Deep Link Scheme

The app uses the `cashi://` scheme for deep links. The Android manifest is configured to handle this scheme.

### Example Deep Links

```
cashi://deeplink?action=openUrl&url=https://example.com&param1=value1&param2=value2
cashi://deeplink?user=john&token=abc123&redirect=home
cashi://deeplink?product=shirt&price=29.99&color=blue&size=M
cashi://deeplink
```

## How to Test

### Method 1: Using the App's Test Buttons
1. Open the app
2. Scroll down to the "Test Deep Links" section
3. Tap any of the test buttons to simulate different deep link scenarios
4. The parameters will be displayed in the "Deep Link Parameters" section

### Method 2: Using ADB (Android Debug Bridge)
```bash
# Test with multiple parameters
adb shell am start -W -a android.intent.action.VIEW -d "cashi://deeplink?action=openUrl&url=https://example.com&param1=value1&param2=value2" com.example.aplazo_demo_deep_link

# Test user login scenario
adb shell am start -W -a android.intent.action.VIEW -d "cashi://deeplink?user=john&token=abc123&redirect=home" com.example.aplazo_demo_deep_link

# Test product details
adb shell am start -W -a android.intent.action.VIEW -d "cashi://deeplink?product=shirt&price=29.99&color=blue&size=M" com.example.aplazo_demo_deep_link

# Test with no parameters
adb shell am start -W -a android.intent.action.VIEW -d "cashi://deeplink" com.example.aplazo_demo_deep_link
```

### Method 3: Using a Web Browser
1. Open a web browser on your device
2. Navigate to: `cashi://deeplink?action=openUrl&url=https://example.com&param1=value1&param2=value2`
3. The app should open and display the parameters

### Method 4: Using Other Apps
Any app that can open URLs can trigger the deep link:
- Email apps
- Messaging apps
- Note-taking apps
- Any app that supports URL schemes

## Implementation Details

### Android Configuration
- **Scheme**: `cashi`
- **Intent Filter**: Configured in `android/app/src/main/AndroidManifest.xml`
- **Auto Verify**: Enabled for better deep link handling

### Flutter Implementation
- **Method Channel**: Used for communication between Flutter and native Android code
- **State Management**: Tracks deep link URL and parameters in app state
- **UI Updates**: Automatically updates the UI when deep links are detected

### Key Files
- `lib/main.dart`: Main Flutter application with deep link handling
- `android/app/src/main/AndroidManifest.xml`: Android deep link configuration
- `android/app/src/main/kotlin/com/example/aplazo_demo_deep_link/MainActivity.kt`: Native Android deep link handling

## Parameter Display

When a deep link is detected, the app displays:
1. **Full Deep Link URL**: The complete URL that triggered the app
2. **Query Parameters**: A list of all parameters in "name: value" format
3. **Visual Indicators**: Color-coded parameter names and values for easy reading

## Backward Compatibility

The app maintains backward compatibility with the existing deep link implementation:
- Still processes `action=openUrl` and `url` parameters for URL opening
- Preserves existing functionality while adding parameter display

## Troubleshooting

### App Not Opening from Deep Link
1. Ensure the app is installed
2. Check that the deep link scheme matches exactly: `cashi://`
3. Verify the package name in ADB commands matches your app

### Parameters Not Displaying
1. Check that the deep link contains query parameters (after the `?`)
2. Ensure the app is properly handling the deep link event
3. Check the console logs for any error messages

### Testing Issues
1. Make sure ADB is properly connected to your device
2. Verify the package name is correct
3. Try the built-in test buttons first to ensure the app works

## Dependencies

- `flutter`: Core Flutter framework
- `url_launcher`: For opening URLs in external apps
- `webview_flutter`: For displaying web content within the app

## Building and Running

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build for Android
flutter build apk
```

## License

This project is for demonstration purposes.



