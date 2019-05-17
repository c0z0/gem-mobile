import 'package:flutter/material.dart';

class GemColors {
  static var purple = Color(0xFF75489B);
  static var amber = Color(0xFFFFA654);
  static var blueGray = Color(0xFF98A4A8);
  static var text = Color(0xFF484848);
  static var border = Color(0xFFEEEEEE);
}

class TextStyles {
  static var title = TextStyle(
    fontSize: 24,
    color: GemColors.purple,
    fontWeight: FontWeight.w500,
  );

  static var titlebar = TextStyle(
    fontSize: 20,
    color: GemColors.purple,
    fontWeight: FontWeight.w400,
  );

  static var subtitle = TextStyle(
    fontSize: 24,
    color: GemColors.blueGray,
    fontWeight: FontWeight.w500,
  );

  static var input = TextStyle(
    fontSize: 16,
    color: GemColors.text,
  );

  static var secondaryText = TextStyle(
    fontSize: 16,
    color: GemColors.blueGray,
  );

  static var h1 = TextStyle(
      fontSize: 32, color: GemColors.text, fontWeight: FontWeight.w700);

  static var text = TextStyle(
    fontSize: 16,
    color: GemColors.text,
  );

  static var link = TextStyle(
    fontSize: 16,
    color: GemColors.purple,
  );

  static var gemTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: GemColors.text,
  );

  static var error = TextStyle(
    fontSize: 16,
    color: Color(0xFFFF0000),
  );

  static var bold = TextStyle(
      fontSize: 16, color: GemColors.text, fontWeight: FontWeight.w500);
}

class Space {
  static var sml = SizedBox(
    height: 16,
  );
  static var med = SizedBox(
    height: 24,
  );

  static var lrg = SizedBox(
    height: 32,
  );

  static custom(double size) => SizedBox(
        height: size,
      );
}

class HorSpace {
  static var sml = SizedBox(
    width: 16,
  );
  static var med = SizedBox(
    width: 24,
  );

  static var lrg = SizedBox(
    width: 32,
  );

  static custom(double size) => SizedBox(
        width: size,
      );
}
