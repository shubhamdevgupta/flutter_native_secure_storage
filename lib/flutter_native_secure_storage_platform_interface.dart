import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_native_secure_storage_method_channel.dart';

abstract class FlutterNativeSecureStoragePlatform extends PlatformInterface {
  /// Constructs a FlutterNativeSecureStoragePlatform.
  FlutterNativeSecureStoragePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNativeSecureStoragePlatform _instance = MethodChannelFlutterNativeSecureStorage();

  /// The default instance of [FlutterNativeSecureStoragePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNativeSecureStorage].
  static FlutterNativeSecureStoragePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNativeSecureStoragePlatform] when
  /// they register themselves.
  static set instance(FlutterNativeSecureStoragePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
