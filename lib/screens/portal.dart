import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' show Random;

import 'package:Gem/styles.dart';
import 'package:Gem/components/close_button.dart';

class Switch extends StatefulWidget {
  final Function onChange;

  Switch({this.onChange});
  @override
  createState() => _SwitchState();
}

class _SwitchState extends State<Switch> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _switchPosition;
  Animation<Color> _sendTextColor;
  Animation<Color> _recieveTextColor;
  bool _send = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _switchPosition = Tween<double>(begin: 128, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() => setState(() {}));

    _sendTextColor =
        ColorTween(begin: Colors.white, end: GemColors.text).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _recieveTextColor =
        ColorTween(end: Colors.white, begin: GemColors.text).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _onChange() {
    if (_send)
      _animationController.forward();
    else
      _animationController.reverse();
    _send = !_send;
    //widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onChange,
      child: Container(
        margin: EdgeInsets.only(top: 118),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: _switchPosition.value,
                  top: 0,
                  child: Container(
                    width: 128,
                    height: 2,
                    decoration: BoxDecoration(
                      color: GemColors.purple,
                      boxShadow: [
                        BoxShadow(
                          color: GemColors.purple.withAlpha(0x40),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  width: 256,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Recieve',
                          style: TextStyles.text
                              .merge(TextStyle(color: _recieveTextColor.value)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Send',
                          style: TextStyles.text
                              .merge(TextStyle(color: _sendTextColor.value)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String alphabet = 'QWERTYUIOPASDFGHJKLZXCVBNM0123456789';

    return TextEditingValue(
      text: newValue.text
          ?.toUpperCase()
          ?.split('')
          ?.where((f) => alphabet.contains(f))
          ?.join(),
      selection: newValue.selection,
    );
  }
}

class Portal extends StatefulWidget {
  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  TextEditingController _textEditingController = TextEditingController();
  bool _send = true;
  String _code = "";
  String _recieveCode = "";

  String _generateCode() {
    final String alphabet = 'QWERTYUIOPASDFGHJKLZXCVBNM0123456789';
    final r = Random();
    return '${alphabet[r.nextInt(alphabet.length)]}${alphabet[r.nextInt(alphabet.length)]}${alphabet[r.nextInt(alphabet.length)]}';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String code) {
    setState(() {
      _code = _textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CloseButtonStack(
          child: Container(
            child: Column(
              children: <Widget>[
                Switch(
                  onChange: () {},
                ),
                Space.lrg,
                Text(
                  'Enter the code:',
                  style: TextStyles.text,
                ),
                Space.sml,
                Container(
                  width: 127,
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[CodeFormatter()],
                    maxLength: 3,
                    keyboardType: TextInputType.text,
                    maxLengthEnforced: true,
                    onChanged: _onCodeChanged,
                    controller: _textEditingController,
                    style: TextStyles.h1.merge(TextStyle(letterSpacing: 8)),
                    cursorColor: GemColors.text,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFF9F9F9),
                      filled: true,
                      hintText: '* * *',
                      hintStyle: TextStyle(color: Color(0xFFFDDDDDD)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFFF9F9F9),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFFF9F9F9),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFFF9F9F9),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
