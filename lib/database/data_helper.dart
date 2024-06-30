import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class SqlHelpers {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstName TEXT,
        lastName TEXT,
        phoneNumber TEXT,
        email TEXT,
        address TEXT,
        imagePath TEXT
      );
    """);
  }

  static Future<sql.Database> db() async {
    final databasePath = await sql.getDatabasesPath();
    final pathString = path.join(databasePath, 'dbcontact.db');
    print('Database path: $pathString');

    return sql.openDatabase(
      pathString,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print("Creating database...");
        await createTables(database);
      },
    );
  }

  static Future<int> createContact(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String address,
    String imagePath,
  ) async {
    final db = await SqlHelpers.db();
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'imagePath': imagePath,
    };
    final id = await db.insert(
      'contacts',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await SqlHelpers.db();
    return db.query('contacts', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getContact(int id) async {
    final db = await SqlHelpers.db();
    return db.query('contacts', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateContact(
    int id,
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    String address,
    String imagePath,
  ) async {
    final db = await SqlHelpers.db();
    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'imagePath': imagePath,
    };
    final result = await db.update('contacts', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteContact(int id) async {
    final db = await SqlHelpers.db();
    try {
      await db.delete('contacts', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong: $err");
    }
  }
}
