
import 'package:flutter/material.dart';

class ShowMessage{

  static void showAlertDialog(BuildContext context,String title,String content){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title:  Text(title),
        content:Text(content),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:const Text('OK'))
        ],
      );
    });
  }

  static void showSnacbar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}