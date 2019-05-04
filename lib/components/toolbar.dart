import 'package:flutter/material.dart';

import './input.dart';
import '../styles.dart';

class Toolbar extends StatelessWidget {
  final Function onSearchQueryChange;

  Toolbar({this.onSearchQueryChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: <Widget>[
          AddButton(
            onPressed: () {},
          ),
          Expanded(
            child: Input(
              onChanged: onSearchQueryChange,
              flatLeft: true,
              hintText: 'Search...',
            ),
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final onPressed;

  AddButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(children: <Widget>[
        Icon(
          Icons.add,
          size: 16,
          color: Colors.white,
        ),
        Text(
          'Add',
          style: TextStyle(color: Colors.white),
        )
      ]),
      padding: EdgeInsets.all(11),
      color: GemColors.purple,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0))),
      onPressed: onPressed,
    );
  }
}
