import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseCatatan {
  static Future<Database>? _db;

  // databasenya akan disimpan, koneksi ke database (sqllite)
  static Future<Database> get database async {
    return await (_db ??= openDatabase(
      kIsWeb
          ? 'catatan_mahasiswa.db'
          : p.join(await getDatabasesPath(), 'catatan_mahasiswa.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE catatan ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'judul TEXT, '
          'isi TEXT)',
        );
      },
    ));
  }

  // Tambah catatan (create)
  static Future<int> tambah(String judul, String isi) async {
    final db = await database;
    return await db.insert('catatan', {'judul': judul, 'isi': isi});
  }

  // Baca semua catatan (read)
  static Future<List<Map<String, Object?>>> baca() async {
    final db = await database;
    return await db.query('catatan', orderBy: 'id DESC');
  }

  // Edit catatan (update)
  static Future<int> ubah(int id, String judul, String isi) async {
    final db = await database;
    return await db.update(
      'catatan',
      {'judul': judul, 'isi': isi},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hapus catatan (delete)
  static Future<int> hapus(int id) async {
    final db = await database;
    return await db.delete('catatan', where: 'id = ?', whereArgs: [id]);
  }
}
