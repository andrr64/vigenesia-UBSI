import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vigenesia_ubsi/main.dart';
import 'package:vigenesia_ubsi/model/user.dart';

class LayananPengguna {
  static Future<void> login(String email, String password,
      {required void Function(String message) onFailed,
      required void Function(String message, UserModel user) onSuccess}) async {
    final response = await http.post(
      Uri.parse(getApiRoute('user/login')),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    final decodedResponseBody = jsonDecode(response.body);
    if (decodedResponseBody['status']) {
      final UserModel user = UserModel.fromJson(decodedResponseBody['data']);
      onSuccess(decodedResponseBody['message'], user);
    } else {
      onFailed(decodedResponseBody['message']);
    }
  }

  static Future<void> daftar(
      {required String nama,
      required String email,
      required String password,
      required String profesi,
      required void Function(String msg, UserModel user) onSuccess,
      required void Function(String msg) onFailed}) async {
    final response = await http.post(
      Uri.parse(getApiRoute('user/register')),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
        'profesi': profesi,
      }),
    );
    final decodedResponse = jsonDecode(response.body);
    final status = decodedResponse['status'];
    final message = decodedResponse['message'];
    if (status) {
      onSuccess(message, UserModel.fromJson(decodedResponse['data']));
    } else {
      onFailed(message);
    }
  }
}
