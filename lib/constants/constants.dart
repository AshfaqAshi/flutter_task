
import 'package:flutter/material.dart';

class Api{
  static const String LOGIN_API ='http://52.66.224.226/wp-json/wp/v2/signin';
  static const String POST_API='13.232.72.245:3200';
  static const String SOCKET_API='ws://13.232.72.245:8895';
}

class Dimens{
  static const double TEXT_BOX_BORDER=6;
  static const double BUTTON_BORDER=12;
  static const double CARD_RADIUS=13;
  static const double AVATAR_RADIUS=25;
  static const double COMMENT_BOX_RADIUS=12;
  static const double LOGIN_TEXT_BOX_RADIUS=8;
}

class Paddings{
  static const double POST_VIEW_PADDING=14;
  static const double CONTENT_PADDING=12;
  static const double TEXT_BOX_V_PADDING=5;
  static const double TEXT_BOX_H_PADDING=5;

}

class CustomColors{
  static const Color POST_TEXT_BACKGROUND=Color(0xffA9DAFF);
  static const Color POST_TEXT_FORE_COLOR=Color(0xff27628F);
  static const Color VIDEO_THUMBNAIL=Color(0xffA7C2D6);
}