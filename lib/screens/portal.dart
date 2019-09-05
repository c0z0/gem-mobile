import 'package:Gem/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' show Random;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:Gem/styles.dart';
import 'package:Gem/components/close_button.dart';
import 'package:Gem/services/gemServices.dart' show queryPortal, mutatePortal;
import 'package:Gem/components/input.dart';

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
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onChange,
      child: Container(
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

class Receive extends StatefulWidget {
  final String code;

  Receive({this.code});

  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), _queryPortal);
    super.initState();
  }

  _queryPortal(_) async {
    final res = await queryPortal(widget.code);

    if (res.data['portal'] != null) {
      launch(res.data['portal']['href']);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Enter the code to recieve url:',
          style: TextStyles.text,
        ),
        Space.sml,
        Container(
          width: 127,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            color: Color(0xFFF9F9F9),
          ),
          child: Column(
            children: <Widget>[
              Text(
                widget.code,
                style: TextStyles.h1.merge(TextStyle(letterSpacing: 8)),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Portal extends StatefulWidget {
  final String href;

  Portal({this.href: ""});

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _hrefController = TextEditingController();
  bool _send = true;
  String _code = "";
  String _href;
  bool _loading = false;
  String _recieveCode = "";

  String _generateCode() {
    final String alphabet = 'QWERTYUIOPASDFGHJKLZXCVBNM0123456789';
    final r = Random();
    return '${alphabet[r.nextInt(alphabet.length)]}${alphabet[r.nextInt(alphabet.length)]}${alphabet[r.nextInt(alphabet.length)]}';
  }

  @override
  void initState() {
    _recieveCode = _generateCode();
    _href = widget.href;
    _hrefController.text = widget.href;
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _hrefController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String code) {
    setState(() {
      _code = _codeController.text;
    });
  }

  void _onHrefChanged(String href) {
    setState(() {
      _href = _hrefController.text;
    });
  }

  _sendPortal() async {
    setState(() {
      _loading = true;
    });

    await mutatePortal(href: _href, code: _code);

    setState(() {
      _loading = false;
      _code = "";
      _href = "";
      _codeController.text = "";
      _hrefController.text = "";
    });
  }

  Widget _renderSendForm(BuildContext context) {
    return Column(
      children: <Widget>[
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
            controller: _codeController,
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
        _code.length == 3
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Space.sml,
                  Text('Link:', style: TextStyles.secondaryText),
                  Space.custom(8),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 48,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: -12,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Input(
                                onChanged: _onHrefChanged,
                                controller: _hrefController,
                                enabled: true,
                                autoFocus: true,
                                hintText: 'example.com',
                              ),
                            ),
                            IconButton(
                              color: GemColors.purple,
                              icon: Icon(
                                Icons.content_paste,
                                color: GemColors.blueGray,
                              ),
                              onPressed: () async {
                                ClipboardData data =
                                    await Clipboard.getData('text/plain');
                                _hrefController.text = data.text;
                                _hrefController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: data.text.length);
                                // _onUrlChange(data.text);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  PrimaryButton(
                    text: _loading ? 'Loading...' : 'Send',
                    disabled: _href.length == 0 || _loading,
                    onPressed: _sendPortal,
                  )
                ],
              )
            : null,
      ].where((w) => w != null).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CloseButtonStack(
          child: Container(
            margin: EdgeInsets.only(top: 36, left: 28, right: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Gem portal',
                  style: TextStyles.h1,
                ),
                Column(
                  children: <Widget>[
                    Space.lrg,
                    Switch(
                      onChange: () {
                        setState(() {
                          _send = !_send;
                        });
                      },
                    ),
                    Space.lrg,
                    _send
                        ? _renderSendForm(context)
                        : Receive(code: _recieveCode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
