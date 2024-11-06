import 'package:flutter/material.dart';
import 'package:vigensia_ubsi/views/login/custom_login.dart';

void main() {
  runApp(const MyApp());
}

const PROXY_API =
    "http://10.4.21.106/Repository/ViGenSia/vigensia_api/index.php/api/";

String getApiRoute(route) {
  return '$PROXY_API/$route';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'VigenSia',
      home: CustomLoginScreen(),
    );
  }
}
