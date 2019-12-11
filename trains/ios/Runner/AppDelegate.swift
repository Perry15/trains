import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBhNkpofcpMFcpEUn6XHaW_cokAxYyi-V0")
    GMSPlacesClient.provideAPIKey("AIzaSyBhNkpofcpMFcpEUn6XHaW_cokAxYyi-V0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
