import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'database_helper.dart';
import 'halaman_catatan.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const MaterialApp(home: TambahCatatan()));
}

class TambahCatatan extends StatefulWidget {
  const TambahCatatan({super.key});

  @override
  State<TambahCatatan> createState() => _TambahCatatanState();
}

class _TambahCatatanState extends State<TambahCatatan> {
  final judul = TextEditingController(); // fungsinya menyimpan yang diinputkan di text field
  final isi = TextEditingController();

  Future<void> simpan() async {
    if (judul.text.trim().isEmpty || isi.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua kolom wajib diisi')));
      return;
    }

    await DatabaseCatatan.tambah(
      judul.text,
      isi.text,
    ); //di databasenyaa di file database

    if (!mounted) return;

    judul.clear();
    isi.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Catatan berhasil disimpan')));
  }

  @override
  void dispose() {
    judul.dispose();
    isi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: judul,
            decoration: const InputDecoration(labelText: 'Judul Catatan'),
          ),
          TextField(
            controller: isi,
            decoration: const InputDecoration(labelText: 'Isi Catatan'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: simpan, child: const Text('Simpan')),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DaftarCatatan()),
              );
            },
            child: const Text('Lihat Catatan'),
          ),
        ],
      ),
    );
  }
}
