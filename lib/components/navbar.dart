import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:Gem/components/title_bar.dart';
import 'package:Gem/components/toolbar.dart';

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 32,
  height: 32,
);

class NavBar extends StatefulWidget {
  final ScrollController controller;
  final Function onSearchQueryChange;

  static double height = TitleBar.height + Toolbar.height;

  NavBar({@required this.controller, @required this.onSearchQueryChange});

  createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<int> _animation;
  Animation<double> _animationLeftOffset;
  Animation<double> _animationSmallDiamondY;
  Animation<double> _animationSmallDiamondOpacity;

  int _shadowAlpha;
  bool _minimized;

  _max(a, b) {
    return a > b ? a : b;
  }

  _onScroll() {
    bool newMinimized = widget.controller.offset > TitleBar.height;

    if (newMinimized != _minimized) {
      if (newMinimized)
        _animationController.forward();
      else
        _animationController.reverse();
    }

    _minimized = newMinimized;
  }

  @override
  void initState() {
    _minimized = false;
    _shadowAlpha = 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: 0x1F).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          _shadowAlpha = _animation.value;
        });
      });

    _animationLeftOffset = Tween<double>(begin: 0, end: 48).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationSmallDiamondY =
        Tween<double>(begin: -32, end: Toolbar.height / 2 - 16).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));

    _animationSmallDiamondOpacity = Tween<double>(begin: -1, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    widget.controller.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(_shadowAlpha),
            offset: Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (BuildContext context, Widget child) {
          return Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: _max(
                    TitleBar.height +
                        Toolbar.height +
                        1 -
                        widget.controller.offset,
                    Toolbar.height + 1),
              ),
              Positioned(
                top: _max(0 - widget.controller.offset, -TitleBar.height),
                left: 0,
                right: 0,
                child: TitleBar(
                  heroActive: !_minimized,
                ),
              ),
              Positioned(
                top: _max(TitleBar.height - widget.controller.offset, 0.0),
                left: _animationLeftOffset.value,
                right: 0,
                child: Toolbar(
                  onSearchQueryChange: widget.onSearchQueryChange,
                ),
              ),
              Positioned(
                top: _max(
                    Toolbar.height + TitleBar.height - widget.controller.offset,
                    Toolbar.height),
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: Color(0xFFEEEEEE),
                ),
              ),
              Positioned(
                left: 12,
                top: _animationSmallDiamondY.value +
                    _max(TitleBar.height - widget.controller.offset, 0.0),
                child: Opacity(
                  opacity: _max(_animationSmallDiamondOpacity.value, 0.0),
                  child: Hero(
                    tag: _minimized ? 'diamond' : 'innactive-diamond',
                    child: _diamond,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
