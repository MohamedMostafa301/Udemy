import 'package:flutter/material.dart';
import 'package:todo/Cubit/cubit.dart';

Widget dTextFormField({
  @required TextEditingController? controller,
  @required TextInputType? type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  VoidCallback? onTap,
  @required String? Function(String?)? validate,
  @required String? label,
  @required IconData? iconData,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model,BuildContext context)=>Dismissible(
  key: UniqueKey(),
  child:   Padding(

    padding: const EdgeInsets.all(20),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          child: Text('${model['time']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

        ),

        const SizedBox(width: 20,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text('${model['title']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

              Text('${model['date']}',style: TextStyle(color: Colors.grey),),

            ],

          ),

        ),

        const SizedBox(width: 20,),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

            icon: Icon(Icons.check_box,color: Colors.green,)),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'archive', id: model['id']);

            },

            icon: Icon(Icons.archive,color: Colors.grey,)),



      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
