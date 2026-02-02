import 'package:flutter/services.dart';

class SecureChannel {
  static const MethodChannel _channel =
      MethodChannel('flutter_native_secure_storage');

  static Future<T?> invoke<T>(
    String method, [
    Map<String, dynamic>? args,
  ]) async {
    return await _channel.invokeMethod<T>(method, args);
  }
}
