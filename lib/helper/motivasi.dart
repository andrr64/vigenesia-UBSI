import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vigenesia_ubsi/main.dart';
import 'package:vigenesia_ubsi/model/motivasi.dart';
import 'package:vigenesia_ubsi/model/user.dart';

Future<void> postMotivasi({
  required UserModel userdata,
  required String motivasi,
  required void Function(String msg) onSuccess,
  required void Function(String msg) onFailed,
  File? file,
}) async {
  String? firebaseFileUrl;
  try {
    // Jika file tidak null, upload ke Firebase Storage
    if (file != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'motivasi/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      final uploadTask = await storageRef.putFile(file);
      firebaseFileUrl = await uploadTask.ref.getDownloadURL();
    }
    final response = await http.post(
      Uri.parse(getApiRoute('motivasi/post')),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "isi_motivasi": motivasi,
        "link_gambar": firebaseFileUrl ?? '',
        "iduser": userdata.iduser,
      }),
    );

    final decodedResponse = jsonDecode(response.body);
    // Jika operasi server berhasil, kembalikan statusnya
    if (decodedResponse['status']) {
      onSuccess(decodedResponse['message']);
    } else {
      onFailed(decodedResponse['message']);
    }
  } catch (e) {
    onFailed('Gagal: ${e.toString()}');
  }
}

Future<List<MotivasiModel>> getMotivasi() async {
  try {
    // Mengambil data dari API
    final response = await http.get(Uri.parse(getApiRoute('motivasi')));

    if (response.statusCode == 200) {
      // Mengonversi response body ke dalam list JSON
      List<dynamic> data = json.decode(response.body);
      // Mengonversi setiap item dalam data menjadi MotivasiModel dan mengembalikannya dalam bentuk list
      var result = data.map((json) => MotivasiModel.fromJson(json)).toList();
      return result;
    } else {
      // Jika status code bukan 200, anggap ada masalah dengan server
      throw Exception('Gagal memuat data');
    }
  } catch (e) {
    // Menangani error, misalnya jika gagal menghubungi API atau format data salah
    print('$e');
    return [];
  }
}

Future<List<MotivasiModel>> getMotivasiWithId(int id) async {
  try {
    // Mengambil data dari API
    final response =
        await http.get(Uri.parse(getApiRoute('motivasi/get?iduser=$id')));

    if (response.statusCode == 200) {
      // Mengonversi response body ke dalam list JSON
      List<dynamic> data = json.decode(response.body);
      // Mengonversi setiap item dalam data menjadi MotivasiModel dan mengembalikannya dalam bentuk list
      var result = data.map((json) => MotivasiModel.fromJson(json)).toList();
      return result;
    } else {
      // Jika status code bukan 200, anggap ada masalah dengan server
      throw Exception('Gagal memuat data');
    }
  } catch (e) {
    // Menangani error, misalnya jika gagal menghubungi API atau format data salah
    print('$e');
    return [];
  }
}
