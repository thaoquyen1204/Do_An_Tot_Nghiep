import 'package:flutter/material.dart';
class InputDecorations {
  static InputDecoration inputDecoration({
    required String hinttext,
    required String labeltext,
    required Icon icono,
    //  required String? Function(dynamic value) validator
  }){
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
         borderSide:BorderSide(color: Color.fromARGB(255, 102, 210, 237)),
       ),
       focusedBorder: const UnderlineInputBorder(
         borderSide:BorderSide(color: Color.fromARGB(255, 102, 210, 237),width: 2),
       ),
       hintText: hinttext,
       labelText:labeltext,
       prefixIcon: icono,
    );
 }
}