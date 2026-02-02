import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_native_secure_storage_platform_interface.dart';

/// An implementation of [FlutterNativeSecureStoragePlatform] that uses method channels.
class MethodChannelFlutterNativeSecureStorage extends FlutterNativeSecureStoragePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_native_secure_storage');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
