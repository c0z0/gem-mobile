import 'package:flutter/material.dart';

import 'package:Gem/styles.dart' show GemColors;

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool disabled;

  const PrimaryButton({
    Key key,
    this.text = '',
    this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.disabled ? null : this.onPressed,
      highlightElevation: 4,
      elevation: 0,
      child: Text(this.text),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      color: GemColors.purple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      splashColor: Colors.white.withAlpha(0x0F),
      disabledColor: Color(0xFFEFEFEF),
      disabledTextColor: Color(0xFFCCCCCC),
    );
  }
}
