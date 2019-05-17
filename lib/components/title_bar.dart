import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:Gem/styles.dart';
import 'package:Gem/components/menu.dart';

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 40,
  height: 40,
);

class TitleBar extends StatelessWidget {
  static double height = 20 + 3 + 40.0;
  final bool heroActive;

  TitleBar({this.heroActive});

  void _openMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Menu(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 3),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _openMenu(context),
                        child: Hero(
                            tag: heroActive ? 'diamond' : 'innactive-diamond',
                            child: _diamond),
                      ),
                      HorSpace.custom(8),
                      Text(
                        'Gem',
                        style: TextStyles.titlebar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: -10,
              top: -4,
              child: IconButton(
                onPressed: () => _openMenu(context),
                icon: Icon(
                  Icons.menu,
                  color: GemColors.blueGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
