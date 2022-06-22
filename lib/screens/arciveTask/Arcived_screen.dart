import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Cubit/cubit.dart';
import 'package:todo/Cubit/state.dart';
import 'package:todo/componant/textFormFeild.dart';
import 'package:todo/constatns.dart';

class ArcivedTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        listener: (context,state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).archivedTasks;
          if(tasks.isNotEmpty)
          {
            return ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
                separatorBuilder: (context, index) =>
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                itemCount: tasks.length);
          }else{
            return const Center(child: Text('No Tasks Archived Yet!'),);
          }

        },

    ) ;
  }
}
