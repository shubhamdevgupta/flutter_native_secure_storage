import 'src/channel.dart';
import 'src/exceptions.dart';

class SecureStorage {
  SecureStorage._(); // no instance

  /// Save a secret securely
  static Future<void> write(String key, String value) async {
    _validateKey(key);

    try {
      await SecureChannel.invoke('write', {
        'key': key,
        'value': value,
      });
    } catch (e) {
      throw SecureStorageException('Failed to write value');
    }
  }

  /// Read a secret
  static Future<String?> read(String key) async {
    _validateKey(key);

    try {
      return await SecureChannel.invoke<String>('read', {
        'key': key,
      });
    } catch (e) {
      throw SecureStorageException('Failed to read value');
    }
  }

  /// Delete a specific key
  static Future<void> delete(String key) async {
    _validateKey(key);
    await SecureChannel.invoke('delete', {'key': key});
  }

  /// Clear all stored values
  static Future<void> clear() async {
    await SecureChannel.invoke('clear');
  }

  static void _validateKey(String key) {
    if (key.isEmpty) {
      throw SecureStorageException('Key cannot be empty');
    }
  }
}
