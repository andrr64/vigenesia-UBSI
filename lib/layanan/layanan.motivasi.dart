import 'dart:convert';
import 'dart:io';
import 'package:vigenesia_ubsi/main.dart';
import 'package:vigenesia_ubsi/model/motivasi.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vigenesia_ubsi/model/user.dart';

class LayananMotivasi {
  static Future<List<MotivasiModel>> getMotivasi({int? idUser}) async {
    try {
      // Mengambil data dari API
      var rute =
          getApiRoute('motivasi${idUser == null ? '' : '?iduser=$idUser'}');
      final response = await http.get(Uri.parse(rute));
      final decoded = json.decode(response.body);
      if (decoded['status']) {
        List<dynamic> data = decoded['data'];
        var result = data.map((json) => MotivasiModel.fromJson(json)).toList();
        return result;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<dynamic> postMotivasi({
    required UserModel userdata,
    required String motivasi,
    required void Function(String msg) onSuccess,
    required void Function(String msg) onFailed,
    File? file,
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(getApiRoute('motivasi')));

    request.fields['iduser'] = userdata.iduser.toString();
    request.fields['isi_motivasi'] = motivasi;

    if (file != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        'gambar', // Harus sesuai dengan nama field di server Express
        file.path,
        contentType: MediaType('image', 'jpeg'), // Sesuaikan tipe file
      );
      request.files.add(multipartFile);
    }
    var response = await (request.send());
    var responseBody = await response.stream.bytesToString();
    final decodedResponse = jsonDecode(responseBody);
    if (decodedResponse['status']) {
      onSuccess(decodedResponse['message']);
    } else {
      onFailed(decodedResponse['message']);
    }
  }
}
