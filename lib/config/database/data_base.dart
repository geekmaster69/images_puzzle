import 'package:image_puzzle/infrastructure/infrastructure.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Database get db {
    if (_db == null) {
      throw Exception(
        'Database not initialized. Call DatabaseHelper.init() in main() first.',
      );
    }
    return _db!;
  }

  static Future<void> init() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "puzzle_image.db");

    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) {
    return Future.wait([db.execute(GameScoreModel.createTable)]);
  }
}
