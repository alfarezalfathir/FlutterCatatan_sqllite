import 'package:flutter/material.dart';
import 'database_helper.dart';
 
class DaftarCatatan extends StatefulWidget {
  const DaftarCatatan({super.key});
 
  @override
  State<DaftarCatatan> createState() => _DaftarCatatanState();
}
 
class _DaftarCatatanState extends State<DaftarCatatan> {
  List<Map<String, Object?>> catatan = [];
 
  @override
  void initState() {
    super.initState();
    tampilkan();
  }

  Future<void> tampilkan() async {
    final data = await DatabaseCatatan.baca();
 
    if (!mounted) return;
 
    setState(() {
      catatan = data;
    });
  }
 
  Future<void> hapus(int id) async {
    await DatabaseCatatan.hapus(id);
    await tampilkan();
  }
 
  Future<void> edit(Map<String, Object?> data) async {
    final judul = TextEditingController(
      text: data['judul'] as String,
    );
    final isi = TextEditingController(
      text: data['isi'] as String,
    );

    final hasil = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: judul),
              TextField(controller: isi),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, [
                  judul.text,
                  isi.text,
                ]);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
 
    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );
    judul.dispose();
    isi.dispose();
 
    if (hasil == null || !mounted) return;
    if (hasil[0].trim().isEmpty || hasil[1].trim().isEmpty) {
      return;
    }
 
    await DatabaseCatatan.ubah(
      data['id'] as int,
      hasil[0],
      hasil[1],
    );
 
    await tampilkan();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Catatan')),
      body: ListView.builder(
        itemCount: catatan.length,
        itemBuilder: (context, index) {
          final data = catatan[index];
 
          return Card(
            child: ListTile(
              title: Text(data['judul'] as String),
              subtitle: Text(data['isi'] as String),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => edit(data),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => hapus(data['id'] as int),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
