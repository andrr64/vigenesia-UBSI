import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vigenesia_ubsi/helper/motivasi.dart';
import 'package:vigenesia_ubsi/layanan/layanan.motivasi.dart';
import 'package:vigenesia_ubsi/provider/user.dart';
import 'package:vigenesia_ubsi/util/dialog.dart';
import 'package:vigenesia_ubsi/views/components/postingan_motivasi_self.dart';

class SelfProfielPage extends HookConsumerWidget {
  const SelfProfielPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataPengguna = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.chevron_left),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Info
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(dataPengguna.avatarLink),
                    radius: 50,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        handleChangeImage(context, ref);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dataPengguna.nama,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dataPengguna.profesi,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              dataPengguna.email,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Text(
                'Pengaturan Akun',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Heading Postingan
            const Text(
              'Postingan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: LayananMotivasi.getMotivasi(idUser: dataPengguna.iduser),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      for (var motiv in data.data!)
                        KartuPostinganSendiri(
                          userModel: dataPengguna,
                          model: motiv,
                          onUpdated: () {},
                          onDeleted: () {},
                        ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleChangeImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final img = File(pickedFile.path);
        showPromptDialog(context, 'Ganti Profil?', Image.file(img), () async {
          var result = await ref.watch(userProvider.notifier).updateAvatar(img);
          if (result) {
            showSuccessDialog(context, 'Data berhasil diubah');
          } else {
            showErrorDialog(context, 'Gagal');
          }
        });
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }
}
