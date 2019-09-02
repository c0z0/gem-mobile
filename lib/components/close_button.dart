import 'package:flutter/material.dart';

import 'package:Gem/styles.dart';

class CloseButtonStack extends StatelessWidget {
  final Widget child;

  CloseButtonStack({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 2,
          top: 16,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: GemColors.blueGray,
            ),
          ),
        ),
        child
      ],
    );
  }
}
