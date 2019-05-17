import 'package:Gem/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:Gem/styles.dart' show TextStyles, Space;

class Gem extends StatelessWidget {
  final String title;
  final bool favorite;
  final String id;
  final String href;
  final String displayUrl;
  final Function onCopy;
  final Function onLongPress;

  Gem(
      {this.title,
      this.href,
      this.favorite: false,
      this.displayUrl,
      this.onLongPress,
      this.id,
      this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: () {
          launch(href,
              option: CustomTabsOption(
                toolbarColor: Colors.white,
                showPageTitle: true,
                enableDefaultShare: true,
              ));
        },
        splashColor: Colors.black.withAlpha(0x08),
        highlightColor: Colors.black.withAlpha(0x05),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: onLongPress != null ? 12 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Space.sml,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 24),
                          child: Text(
                            title,
                            style: TextStyles.gemTitle,
                          ),
                        ),
                        Space.custom(8),
                        Row(
                          children: <Widget>[
                            favorite
                                ? Icon(
                                    Icons.star,
                                    size: 16,
                                    color: GemColors.blueGray,
                                  )
                                : null,
                            favorite ? HorSpace.custom(8) : null,
                            Text(
                              displayUrl,
                              style: TextStyles.secondaryText,
                            ),
                          ].where((w) => w != null).toList(),
                        ),
                      ],
                    ),
                  ),
                  onLongPress != null
                      ? IconButton(
                          onPressed: onLongPress,
                          // alignment: Alignment.centerRight,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.more_vert,
                            color: GemColors.blueGray,
                            size: 20,
                          ),
                        )
                      : null,
                ].where((w) => w != null).toList(),
              ),
              Space.sml,
              Container(
                height: 1,
                color: Color(0xFFEEEEEE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GemPlaceholder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GemPlaceholderState();
}

class _GemPlaceholderState extends State<GemPlaceholder>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.black.withAlpha(0x8),
          end: Colors.black.withAlpha(0xD),
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          end: Colors.black.withAlpha(0x8),
          begin: Colors.black.withAlpha(0xD),
        ),
      ),
    ]).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _color = _animation.value;
    final _secondColor = _color;

    final _decoration = BoxDecoration(
      color: _color,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    final _secondDecoration = BoxDecoration(
      color: _secondColor,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );

    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: .90,
            child: Container(
                height: 16,
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: _decoration),
          ),
          FractionallySizedBox(
            widthFactor: .75,
            child: Container(
              height: 16,
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: _decoration,
            ),
          ),
          Space.custom(12),
          FractionallySizedBox(
            widthFactor: .25,
            child: Container(
              height: 12,
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: _secondDecoration,
            ),
          ),
          Space.sml,
          Container(
            height: 1,
            color: Color(0xFFEEEEEE),
          ),
        ],
      ),
    );
  }
}
