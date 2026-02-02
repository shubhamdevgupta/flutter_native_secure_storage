import 'package:flutter/material.dart';
import 'package:flutter_native_secure_storage/flutter_native_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Secure Storage Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await SecureStorage.write('token', 'abc123');
              final token = await SecureStorage.read('token');
              debugPrint('Token: $token');
            },
            child: const Text('Test Secure Storage'),
          ),
        ),
      ),
    );
  }
}
