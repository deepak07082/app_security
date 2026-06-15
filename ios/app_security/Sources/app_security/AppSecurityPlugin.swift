import Flutter
import UIKit

public class AppSecurityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_security", binaryMessenger: registrar.messenger())
    let instance = AppSecurityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    AppSecurityApiSetup.setUp(binaryMessenger: registrar.messenger(), api: AppSecurityApiImpl())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}


