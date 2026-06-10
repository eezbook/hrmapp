import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase? _instance;
  static Database? _db;

  AppDatabase._();

  static Future<AppDatabase> getInstance() async {
    _instance ??= AppDatabase._();
    _db ??= await _instance!._initDb();
    return _instance!;
  }

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hrm_offline.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pending_sync_queue (
            id          TEXT PRIMARY KEY,
            action      TEXT NOT NULL,
            payload     TEXT NOT NULL,
            created_at  TEXT NOT NULL,
            retry_count INTEGER DEFAULT 0,
            last_error  TEXT DEFAULT '',
            synced_at   TEXT
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_synced_at ON pending_sync_queue(synced_at)',
        );
      },
    );
  }

  Future<void> insertPendingAction(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert('pending_sync_queue', row);
  }

  /// Returns unsynced rows with fewer than 3 retries, oldest first.
  Future<List<Map<String, dynamic>>> getPendingActions() async {
    final db = await database;
    return db.query(
      'pending_sync_queue',
      where: 'synced_at IS NULL AND retry_count < ?',
      whereArgs: [3],
      orderBy: 'created_at ASC',
    );
  }

  /// Marks a row as synced. Rows are never deleted — this preserves the audit trail.
  Future<void> markSynced(String id) async {
    final db = await database;
    await db.update(
      'pending_sync_queue',
      {'synced_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> incrementRetry(String id, String errorMessage) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE pending_sync_queue SET retry_count = retry_count + 1, last_error = ? WHERE id = ?',
      [errorMessage, id],
    );
  }

  Future<int> getPendingCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS cnt FROM pending_sync_queue WHERE synced_at IS NULL AND retry_count < 3',
    );
    return result.first['cnt'] as int? ?? 0;
  }
}
