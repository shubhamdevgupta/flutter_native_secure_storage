import Flutter
import UIKit

public class FlutterNativeSecureStoragePlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
        name: "flutter_native_secure_storage",
        binaryMessenger: registrar.messenger()
    )
    let instance = FlutterNativeSecureStoragePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(
    _ call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    guard let args = call.arguments as? [String: Any],
          let key = args["key"] as? String || call.method == "clear"
    else {
        result(FlutterError(
            code: "INVALID_ARGUMENTS",
            message: "Invalid arguments",
            details: nil
        ))
        return
    }

    do {
        switch call.method {

        case "write":
            let value = args["value"] as! String
            try KeychainHelper.save(key: key, value: value)
            result(nil)

        case "read":
            let value = try KeychainHelper.read(key: key)
            result(value)

        case "delete":
            KeychainHelper.delete(key: key)
            result(nil)

        case "clear":
            KeychainHelper.clear()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    } catch {
        result(FlutterError(
            code: "SECURE_STORAGE_ERROR",
            message: error.localizedDescription,
            details: nil
        ))
    }
  }
}
