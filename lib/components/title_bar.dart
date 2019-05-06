import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 40,
  height: 40,
);

class TitleBar extends StatelessWidget {
  static double height = 20 + 3 + 40.0;
  final bool heroActive;

  TitleBar({this.heroActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Hero(
                    tag: heroActive ? 'diamond' : 'innactive-diamond',
                    child: _diamond),
                HorSpace.custom(8),
                Text(
                  'Gem',
                  style: TextStyles.titlebar,
                )
              ],
            ),
          ),
          GestureDetector(
            child: Text('Logout', style: TextStyles.text),
            onTap: () async {
              SharedPreferences storage = await SharedPreferences.getInstance();

              storage.remove('session');

              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
      ),
    );
  }
}
