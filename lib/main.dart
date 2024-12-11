import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vigenesia_ubsi/provider/user.dart';
import 'package:vigenesia_ubsi/views/home/homescreen.dart';
import 'package:vigenesia_ubsi/views/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const ProviderScope(child: MyApp())); // Tambahkan ProviderScope
}

const SERVER_API =
    "http://192.168.1.9:8080/api";

String getApiRoute(route) {
  return '$SERVER_API/$route';
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
