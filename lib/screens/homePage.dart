import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Cubit/cubit.dart';
import 'package:todo/Cubit/state.dart';
import 'package:todo/componant/textFormFeild.dart';
import 'package:todo/screens/Tasks/task_screen.dart';
import 'package:todo/screens/arciveTask/Arcived_screen.dart';
import 'package:todo/screens/doneTask/Done_screen.dart';

import '../constatns.dart';

class HomePage extends StatelessWidget
{
  static String routeName = '/home';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDb(),
      child: BlocConsumer<AppCubit,AppState>(
        listener:(context,AppState state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder: (context,AppState state){
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isButtonSheetOpen) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(title: titleController.text, date: dateController.text, time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            dTextFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              label: 'Task title',
                              iconData: Icons.title,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            dTextFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  if (value != null) {
                                    timeController.text =
                                        value.format(context).toString();
                                  } else {
                                    return;
                                  }
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              label: 'Time',
                              iconData: Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            dTextFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-07-16'),
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  } else {
                                    return;
                                  }
                                });
                              },
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              label: 'date',
                              iconData: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    );
                  },elevation: 20).closed.then((value) {
                   cubit.changeButtonSheetState(isShow: false);
                  });
                  cubit.changeButtonSheetState(isShow: true);
                }
              },
              child: cubit.isButtonSheetOpen == false
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive'),
              ],
            ),
          );
        })
    );
  }


}




