import 'package:path/path.dart';
import 'package:phone_app/phoneDetails.dart';
import 'package:sqflite/sqflite.dart';
class PhoneProvider{
  Database? database;
  late String tableName='contact';
  Future onCreateDatabase(Database database, int version) async{
    await database.execute('CREATE TABLE $tableName('
        'id INTEGER PRIMARY KEY, name TEXT, number TEXT, cover TEXT)');
  }

  Future <Database?> initDatabase() async{
    if( database != null){
      return database;
    }
    String path= join(await getDatabasesPath(),'contacts.db');
    database = await openDatabase(path,version: 1,onCreate:onCreateDatabase );
    return database;
  }
  Future<List<Map<String, dynamic>>> getDtaFromDatabase() async {
    Database? database = await initDatabase();
    return await database!.query(tableName);
  }
  Future insertIntoDatabase(PhoneDetails phoneDetails) async{
    Database? database = await initDatabase();
    return await database!.insert(tableName, phoneDetails.toMap());
  }
  Future<int> deleteFromDatabase(int id) async {
    Database? database = await initDatabase();
    return await database!.delete(tableName,  where: 'id= ?', whereArgs: [id]);
  }
  contactUpdate(PhoneDetails phoneDetails) async {
    Database? database = await initDatabase();
    return await database!.update(tableName, phoneDetails.toMap(),
        where: 'id = ?', whereArgs: [phoneDetails.id]);
  }
}