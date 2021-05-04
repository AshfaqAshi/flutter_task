
import 'package:flutter/material.dart';

class Utilities{

  static  Widget verticalSpace({double height=10}){
    return SizedBox(
      height: height,
    );
  }

  static Widget horizontalSpace({double width=10}){
    return SizedBox(
      width: width,
    );
  }
}