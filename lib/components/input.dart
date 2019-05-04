import 'package:flutter/material.dart';

import '../styles.dart';

var _border = OutlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xFFDDDDDD),
  ),
  borderRadius: const BorderRadius.all(
    Radius.circular(7.0),
  ),
);

var _borderFlatLeft = OutlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xFFDDDDDD),
  ),
  borderRadius: const BorderRadius.only(
    topRight: Radius.circular(7.0),
    bottomRight: Radius.circular(7.0),
  ),
);

class Input extends StatefulWidget {
  final String hintText;
  final bool autoFocus;
  final bool enabled;
  final Function onChanged;
  final Function onSubmitted;
  final TextInputType keyboardType;
  final bool flatLeft;

  Input(
      {this.hintText = '',
      this.onChanged,
      this.keyboardType,
      this.autoFocus: false,
      this.enabled: true,
      this.flatLeft: false,
      this.onSubmitted});
  @override
  createState() => _InputState();
}

class _InputState extends State<Input> {
  FocusNode _focus = new FocusNode();

  var _focused;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _focused = widget.autoFocus;
  }

  _onFocusChange() {
    setState(() {
      _focused = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyles.input,
      focusNode: _focus,
      enabled: this.widget.enabled,
      autofocus: this.widget.autoFocus,
      onChanged: this.widget.onChanged,
      keyboardType: this.widget.keyboardType,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: this.widget.hintText,
        filled: _focused,
        hintStyle: TextStyle(color: Color(0xFFFDDDDDD)),
        contentPadding: EdgeInsets.all(10),
        fillColor: Color(0xFFFAFAFA),
        focusedBorder: widget.flatLeft ? _borderFlatLeft : _border,
        enabledBorder: widget.flatLeft ? _borderFlatLeft : _border,
      ),
      cursorColor: GemColors.text,
      cursorWidth: 1,
    );
  }
}
