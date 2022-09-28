import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DbRepo {
  late Database _db;

  Future<void> openDb()async{

    String dbpath = await getDatabasesPath();
    String dbname = "todo_app.db";
    String finalDb = join(dbpath,dbname);

    _db = await openDatabase(
        finalDb,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, todotext TEXT, isDone INTEGER)',
        );
      },
      version: 1
    );
  }
  Future<void> insertDb(Map< String , dynamic> data, String tableName) async{
    await _db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  Future<List<Map<String , dynamic>>>retrieveDB(String tableName) async{
    List<Map<String, dynamic>> list;
    list = await _db.query(tableName);
    return list;
  }
  Future<void> updateDb(String tablename , Map<String , dynamic> newValues , int id) async {
    await _db.update(tablename, newValues, where: 'id = ?' , whereArgs: [id]);}
  Future<void> deleteDb(String tablename , int id) async{
    await _db.delete(tablename ,where: 'id = ?' , whereArgs: [id]);}

}