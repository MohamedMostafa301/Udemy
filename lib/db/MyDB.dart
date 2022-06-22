import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb{
  static Database? _db;
  Future<Database?> get db async{
    if(_db==null){
      _db = await intialDb();
      return _db;
    }else{
      return _db;
    }
  }

  intialDb() async{
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath,'todo.db');
    Database myDb= await openDatabase(path,onCreate: _onCreate,version:3,onUpgrade: _onUpgrade);
    return myDb;
  }
  _onUpgrade(Database db , int oldVersion , int newVersion)async{
   // await db.execute('ALTER TABLE table_name ADD COLUMN column_name TEXT');
  }
  _onCreate(Database db , int version)async{
    await db.execute('''
    CREATE TABLE "task" (
    "ID" INTEGER NOT NULL PRIMARY KEY ,
    "title" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "status" TEXT NOT NULL
    )
    ''');
    print('create db ---------------');
  }
//select
  readData(String sql)async{
    Database? myDb = await db;
    Future<List<Map>> response = myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql)async{
    Database? myDb = await db;
    Future<int> response = myDb!.rawInsert(sql);
    return response;
  }
  updateData(String sql)async{
    Database? myDb = await db;
    Future<int> response = myDb!.rawUpdate(sql);
    return response;
  }
  deleteData(String sql)async{
    Database? myDb = await db;
    Future<int> response = myDb!.rawDelete(sql);
    return response;
  }

  deleteDb()async{
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath,'hamada.db');
    await deleteDatabase(path);
    print('delete db --------------');
  }

}