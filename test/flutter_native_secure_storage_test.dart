import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_secure_storage/flutter_native_secure_storage.dart';
import 'package:flutter_native_secure_storage/flutter_native_secure_storage_platform_interface.dart';
import 'package:flutter_native_secure_storage/flutter_native_secure_storage_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNativeSecureStoragePlatform
    with MockPlatformInterfaceMixin
    implements FlutterNativeSecureStoragePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterNativeSecureStoragePlatform initialPlatform = FlutterNativeSecureStoragePlatform.instance;

  test('$MethodChannelFlutterNativeSecureStorage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNativeSecureStorage>());
  });

  test('getPlatformVersion', () async {
    FlutterNativeSecureStorage flutterNativeSecureStoragePlugin = FlutterNativeSecureStorage();
    MockFlutterNativeSecureStoragePlatform fakePlatform = MockFlutterNativeSecureStoragePlatform();
    FlutterNativeSecureStoragePlatform.instance = fakePlatform;

    expect(await flutterNativeSecureStoragePlugin.getPlatformVersion(), '42');
  });
}
