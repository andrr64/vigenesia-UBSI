import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vigenesia_ubsi/model/user.dart';
import 'package:vigenesia_ubsi/provider/motivasi.dart';
import 'package:vigenesia_ubsi/provider/user.dart';
import 'package:vigenesia_ubsi/views/components/postingan_motivasi.dart';
import 'package:vigenesia_ubsi/views/components/postingan_motivasi_self.dart';
import 'package:vigenesia_ubsi/views/components/snackbar.dart';
import 'package:vigenesia_ubsi/views/login/login.dart';
import 'package:vigenesia_ubsi/views/post-motivasi/post_motivasi.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vigenesia_ubsi/views/profil/profile_sendiri.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

Widget dHeight(double h) {
  return SizedBox(
    height: h,
  );
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController teksMotivasi = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(motivasiProvider.notifier).fetchMotivasi();
    });
  }

  Widget writeSomethingInHere(
      BuildContext context, String avatarLink, UserModel userdata) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarLink),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 10),
              // Input field
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Ketik motivasi disini...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  controller: teksMotivasi,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo, color: Colors.black87),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage == null) return;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostMotivasi(
                                    callback: () {
                                      teksMotivasi.text = '';
                                      ref
                                          .read(motivasiProvider.notifier)
                                          .fetchMotivasi();
                                    },
                                    image: pickedImage,
                                    motivasi: teksMotivasi.text,
                                  )));
                    },
                  ),
                ],
              )),
              const SizedBox(width: 2.5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                onPressed: () async {
                  if (teksMotivasi.text.isNotEmpty) {
                    try {

                    } catch (e) {
                      showFailedSnackbar(context, 'Gagal');
                    } finally {
                      context.loaderOverlay.hide();
                    }
                  }
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void updateData() {
    ref.read(motivasiProvider.notifier).fetchMotivasi();
  }

  @override
  Widget build(BuildContext context) {
    final dataPengguna = ref.watch(userProvider)!;
    final motivasiList = ref.watch(motivasiProvider);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Mencegah mengambil ruang penuh
          mainAxisAlignment: MainAxisAlignment.end, // Menempatkan di bawah
          crossAxisAlignment: CrossAxisAlignment.end, // Rata kanan
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(motivasiProvider.notifier).fetchMotivasi();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10), // Jarak antar tombol
            ElevatedButton(
              onPressed: () {
                ref.read(motivasiProvider.notifier).fetchMotivasi();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
            SpeedDial(
              icon: Icons.menu,
              activeIcon: Icons.close,
              backgroundColor: Colors.black87,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.refresh, color: Colors.white),
                  label: 'Refresh',
                  backgroundColor: Colors.black87,
                  onTap: () {
                    ref.read(motivasiProvider.notifier).fetchMotivasi();
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add, color: Colors.white),
                  label: 'Add',
                  backgroundColor: Colors.black87,
                  onTap: () {
                    // Tambahkan logika di sini
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/img/logo.png',
          height: 40,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withAlpha(50), // Warna border
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 241, 242, 245),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              writeSomethingInHere(
                  context, dataPengguna.avatarLink, dataPengguna),
              const Text(
                'Postingan',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              motivasiList.isEmpty
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 100),
                        child: const Text('Tidak ada postingan.'),
                      ),
                    )
                  : Column(
                      children: [
                        for (var motiv in motivasiList)
                          dataPengguna.iduser == motiv.user.iduser
                              ? KartuPostinganSendiri(
                                  userModel: dataPengguna,
                                  model: motiv,
                                  onUpdated: updateData,
                                  onDeleted: updateData)
                              : KartuPostingan(model: motiv)
                      ],
                    )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Drawer
            UserAccountsDrawerHeader(
              accountName: Text(dataPengguna.nama),
              accountEmail: Text(dataPengguna.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(dataPengguna.avatarLink),
              ),
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
            ),
            // Menu Profil
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SelfProfielPage()));
              },
            ),
            // Menu Pengaturan Akun
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan Akun'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         PengaturanAkunPage(userModel: dataPengguna),
                //   ),
                // );
              },
            ),
            // Menu Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Apakah Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen())); // Menutup dialog
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
