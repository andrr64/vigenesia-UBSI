import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vigenesia_ubsi/provider/user.dart';
import 'package:vigenesia_ubsi/views/home/homescreen.dart';
import 'package:vigenesia_ubsi/views/login/login.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // Tambahkan ProviderScope
}

const proxy =
    "http://localhost/Repository/ViGenSia/vigensia_api/index.php/api/";

String getApiRoute(route) {
  return '$proxy/$route';
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget getHome() {
      if (ref.read(userProvider) == null) {
        return const LoginScreen();
      } else {
        return const HomeScreen();
      }
    }

    return MaterialApp(
      title: 'VigenSia',
      home: LoaderOverlay(child: getHome()),
    );
  }
}
