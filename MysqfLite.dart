MySqflite.dart
import 'package:explore_data/useCase/sqflite/MahasiswaModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MySqflite {
  static final _databaseName = "MyDatabase.db";

  static final _databaseV1 = 1;
  static final tableAtletVolly = 'atletvolly';

  static final columnNim = 'no';
  static final columnName = 'name';
  static final columnDepartment = 'position';
  static final columnSKS = 'power';

  // make this a singleton class
  MySqflite._privateConstructor();

  static final MySqflite instance = MySqflite._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(path, version: _databaseV1,
        onCreate: (db, version) async {
      var batch = db.batch();
      _onCreateTableAtletVolly(batch);

      await batch.commit();
    });
  }

  void _onCreateTableAtletVolly(Batch batch) async {
    batch.execute('''
          CREATE TABLE $tableAtletVolly(
            $columnNo TEXT PRIMARY KEY,
            $columnName TEXT,
            $columnPosition TEXT,
            $columnPower INTEGER
          )
          ''');
  }

  ///TABLE AtletVolly
  Future<int> insertAtletVolly(AtletVollyModel model) async {
    var row = {
      columnNim: model.no,
      columnName: model.name,
      columnDepartment: model.position,
      columnSKS: model.power
    };

    Database db = await instance.database;
    return await db.insert(tableAtletVolly, row);
  }

  Future<List<AtletVollyModel>> getAtletVolly() async {
    Database db = await instance.database;
    var allData = await db.rawQuery("SELECT * FROM $tableAtletVolly");

    List<AtletVollyModel> result = [];
    for (var data in allData) {
      result.add(AtletVollyModel(
          nim: data[columnNim],
          name: data[columnName],
          department: data[columnDepartment],
          sks: int.parse(data[columnSKS].toString())));
    }

    return result;
  }

  Future<AtletVollyModel> getAtletVollyByNIM(String no) async {
    Database db = await instance.database;
    var allData = await db.rawQuery(
        "SELECT * FROM $tableAtletVolly WHERE $columnNo = $no LIMIT 1");

    if (allData.isNotEmpty) {
      return AtletVollyModel(
          no: allData[0][columnNo],
          name: allData[0][columnName],
          position: allData[0][columnposition],
          power: int.parse(allData[0][columnPower]));
    } else {
      return null;
    }
  }

  Future<int> updateAtletVollypower(AtletVollyModel model) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE $tableAtletVolly SET $columnPower = ${model.power} '
        'Where $columnNo = ${model.no}');
  }

  Future<int> deleteAtletVolly(String no) async {
    Database db = await instance.database;
    return await db
        .rawDelete('DELETE FROM $tableAtletVolly Where $columnNo = $no');
  }

  clearAllData() async {
    Database db = await instance.database;
    await db.rawQuery("DELETE FROM $tableAtletVolly");
  }
}
