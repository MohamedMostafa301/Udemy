import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Cubit/state.dart';

import '../screens/Tasks/task_screen.dart';
import '../screens/arciveTask/Arcived_screen.dart';
import '../screens/doneTask/Done_screen.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  Database? db;
  List<Widget> screen = [
    TaskScreen(),
    DoneScreen(),
    ArcivedTaskScreen(),
  ];
  List<String> title = ['New Task', 'Done Task', 'Archive Task'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeButtonNavState());
  }

  void createDb() {
    openDatabase('todo.db', version: 2, onCreate: (dataBase, version) {
      print('database created');
      dataBase.execute('''
      CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT,date TEXT, status TEXT,time TEXT)
      ''').then((value) {
        print('table created');
      }).catchError((error) {
        print('error in create table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('database opened');
    }).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await db!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO task(title,date,status,time) VALUES ("$title","$date","new","$time")')
          .then((value) {
        print('inserted success');
        emit(AppInsertDatabaseState());
        getDataFromDataBase(db!);
      }).catchError((error) {
        print('error in insert data ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(Database database) async {
     database.rawQuery('SELECT * FROM task').then((value) {
       value.forEach((element) {
         if(element['status']=='new') {
           newTasks.add(element);
         } else if(element['status']=='done') {
           doneTasks.add(element);
         } else {
           archivedTasks.add(element);
         }
       });
       emit(AppGetDatabaseState());
     });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    archivedTasks=[];
    doneTasks=[];
    newTasks=[];
     db!.rawUpdate('UPDATE task SET status = ? WHERE id =?',[status,'$id']).then((value) {
       getDataFromDataBase(db!);
       emit(AppUpdateDatabaseState());
     });
  }

  void deleteData({
    required int id,
  }) async {
    archivedTasks=[];
    doneTasks=[];
    newTasks=[];
    db!.rawDelete('DELETE FROM task WHERE id =?',[id]).then((value) {
      getDataFromDataBase(db!);
      emit(AppDeleteDatabaseState());
      print('delete value');
    });
  }

//buttonSheetLogic
  bool isButtonSheetOpen = false;

  void changeButtonSheetState({required bool isShow}) {
    isButtonSheetOpen = isShow;
    emit(AppChangeButtonSheetState());
  }
}
