# 🔐 flutter_native_secure_storage

A lightweight, secure Flutter plugin for storing sensitive data using  
**Android Keystore** and **iOS Keychain** — with **no Dart-side encryption**.

Built for production apps, SDKs, and enterprise use cases.

---

## ✨ Features

✅ Android Keystore (AES-256 + GCM)  
✅ iOS Keychain (ThisDeviceOnly)  
✅ Hardware-backed security when available  
✅ App-bound secrets (auto wiped on uninstall)  
✅ Zero configuration  
✅ Minimal & clean API  
✅ No third-party native dependencies  

---

## 🚫 Why NOT flutter_secure_storage?

| Feature | flutter_secure_storage | flutter_native_secure_storage |
|------|----------------------|------------------------------|
| Native-only crypto | ❌ | ✅ |
| Hardware-backed keys | ❌ | ✅ |
| Transparent behavior | ❌ | ✅ |
| Enterprise friendly | ⚠️ | ✅ |
| Minimal API | ❌ | ✅ |

---

## 📦 Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_native_secure_storage: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

### Write Secure Value
```dart
await SecureStorage.write('auth_token', 'abc123');
```

### Read Secure Value
```dart
final token = await SecureStorage.read('auth_token');
```

### Delete a Key
```dart
await SecureStorage.delete('auth_token');
```

### Clear All Secure Data
```dart
await SecureStorage.clear();
```

---

## 🧠 How It Works

### Android
- AES key stored in **Android Keystore**
- Encryption: **AES/GCM/NoPadding**
- Encrypted values stored in SharedPreferences

### iOS
- Secrets stored in **Keychain**
- Access: `AfterFirstUnlockThisDeviceOnly`
- Automatically removed on uninstall

📌 No encryption logic exists in Dart.

---

## 🔐 Security Guarantees

✔ Secrets never leave the device  
✔ No cloud or iCloud sync  
✔ Protected from backup leaks  
✔ Resistant to reverse-engineering  
✔ Safe for banking & enterprise apps  

---

## 🧪 Platform Support

- Android 8+
- iOS 13+

---

## 🛣 Roadmap

- 🔒 Biometric protection (FaceID / Fingerprint)
- 🔄 Key rotation
- 🛡 Root / Jailbreak detection
- 📁 Encrypted file storage

---

## 📄 License

MIT License
