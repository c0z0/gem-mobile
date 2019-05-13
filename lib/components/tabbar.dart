import 'package:flutter/material.dart';

import '../styles.dart';

class TabBar extends StatelessWidget {
  final Function(int index) onTap;
  final int activeIndex;

  TabBar({this.onTap, this.activeIndex});

  Color _getColor(int index) {
    return activeIndex == index ? GemColors.purple : GemColors.blueGray;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(height: 1, color: GemColors.border),
        Material(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    onTap(0);
                  },
                  icon: Icon(
                    Icons.home,
                    size: 28,
                    color: _getColor(0),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap(1);
                  },
                  icon: Icon(
                    activeIndex == 1 ? Icons.star : Icons.star_border,
                    size: 28,
                    color: _getColor(1),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap(1);
                  },
                  icon: Icon(
                    Icons.menu,
                    size: 28,
                    color: _getColor(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
