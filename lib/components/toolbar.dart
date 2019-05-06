import 'package:flutter/material.dart';

import './input.dart';
import '../styles.dart';

class Toolbar extends StatelessWidget {
  static double height = 3 * 2 + 16 + 10 * 2.0 + 12;

  final Function onSearchQueryChange;

  Toolbar({this.onSearchQueryChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      child: Row(
        children: <Widget>[
          Hero(
            tag: 'add-button',
            child: AddButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add');
              },
            ),
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
          style: TextStyle(color: Colors.white, fontSize: 16),
        )
      ]),
      padding: EdgeInsets.all(10),
      color: GemColors.purple,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0))),
      onPressed: onPressed,
    );
  }
}
