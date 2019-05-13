import 'package:flutter/material.dart';

import './input.dart';
import '../styles.dart';

class Toolbar extends StatelessWidget {
  static double height =
      16 + 9 * 2 + 1.0 + 8 + 8; // 3 * 2 + 16 + 10 * 2.0 + 12;

  final Function onSearchQueryChange;

  Toolbar({this.onSearchQueryChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 6),
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
    return Container(
      padding: EdgeInsets.only(left: 1, top: 1, bottom: 1),
      decoration: BoxDecoration(
        color: Color(0xFFDDDDDD),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0)),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 16,
                  color: GemColors.purple,
                ),
                Text(
                  'Add',
                  style: TextStyle(
                      color: GemColors.purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
