import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vigenesia_ubsi/main.dart';
import 'package:vigenesia_ubsi/model/user.dart';

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(null);

  // Metode untuk login (mengupdate state dengan data dari JSON)
  void login(Map<String, dynamic> json) {
    state = UserModel.fromJson(json);
  }

  void loginWithModel(UserModel user) {
    state = user;
  }

  // Metode untuk logout (menghapus data user)
  void logout() {
    state = null; // Set state menjadi null saat logout
  }

  Future<bool> updateAvatar(File file) async {
    try {
      // Upload file ke Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      final avatarRef = storageRef.child(
          'vigenesia/avatars/${DateTime.now().toIso8601String()}.${file.path}');
      final uploadTask = avatarRef.putFile(file);

      // Tunggu hingga upload selesai
      final snapshot = await uploadTask.whenComplete(() => null);
      final urlProfilBaru = await snapshot.ref.getDownloadURL();

      final dataTerbaru = state!.copyWith(avatarLink: urlProfilBaru);

      final response =
          await http.put(Uri.parse(getApiRoute('user_util/update')),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(dataTerbaru.toJson()));
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception('gagal mengupdate di database');
      }
      state = dataTerbaru;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Metode untuk mengupdate data user
  void updateUserData(UserModel updateUser) {
    if (state != null) {
      state = updateUser;
    }
  }
}

// Deklarasi StateNotifierProvider yang mendukung nilai null untuk UserModel
final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});
