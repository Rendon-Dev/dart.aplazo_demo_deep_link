import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up method channel for deep links
    let controller = window?.rootViewController as! FlutterViewController
    let deepLinkChannel = FlutterMethodChannel(
      name: "com.example.aplazo_demo_deep_link/deeplink",
      binaryMessenger: controller.binaryMessenger
    )
    
    // Store the channel for later use
    objc_setAssociatedObject(self, "deepLinkChannel", deepLinkChannel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    
    // Check for initial deep link
    if let url = launchOptions?[.url] as? URL {
      handleDeepLink(url: url, channel: deepLinkChannel)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle deep link when app is already running
    if let channel = objc_getAssociatedObject(self, "deepLinkChannel") as? FlutterMethodChannel {
      handleDeepLink(url: url, channel: channel)
    }
    return true
  }
  
  private func handleDeepLink(url: URL, channel: FlutterMethodChannel) {
    DispatchQueue.main.async {
      channel.invokeMethod("onDeepLink", arguments: url.absoluteString)
    }
  }
}
