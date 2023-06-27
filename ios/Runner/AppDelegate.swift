import UIKit
import Flutter
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // !! how to know ShareMedia url(CFBundleURLSchemes)
    // flutterEngine.run();x
    // let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    // let shareChannel = FlutterMethodChannel(name: "com.beside.moa/share",
    //                                           binaryMessenger: controller.binaryMessenger)
    // shareChannel.setMethodCallHandler({
    //   (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    //   switch call.method {
    //     case "mainScreen":
    //         result("mainScreen")
    //     default:
    //         break
    //     }
    // })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
