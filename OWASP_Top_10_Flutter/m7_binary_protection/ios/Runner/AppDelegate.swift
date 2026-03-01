import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    // Register Flutter-generated plugins (from pub packages)
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Register M7 binary protection plugins
    IntegrityPlugin.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "IntegrityPlugin")!)
    RootDetectionPlugin.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "RootDetectionPlugin")!)
    SecretProvider.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "SecretProvider")!)
  }
}
