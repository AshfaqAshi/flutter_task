import 'package:flutter/material.dart';
import 'package:flutter_technical_task/constants/constants.dart';

class RoundedTextField extends StatelessWidget {
  String helperText;
  String hintText;
  TextEditingController controller;

  RoundedTextField({this.controller,this.helperText,this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.TEXT_BOX_BORDER),
        ),
        hintText: hintText,
        helperText: helperText,
        contentPadding: EdgeInsets.symmetric(vertical: Paddings.TEXT_BOX_V_PADDING,horizontal: Paddings.TEXT_BOX_H_PADDING)
      ),
    );
  }
}
