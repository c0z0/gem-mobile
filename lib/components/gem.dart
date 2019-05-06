import 'package:Gem/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../styles.dart' show TextStyles, Space;

class Gem extends StatelessWidget {
  final String title;
  final String id;
  final String href;
  final String displayUrl;
  final Function onLongPress;

  Gem({this.title, this.href, this.displayUrl, this.onLongPress, this.id});

  @override
  Widget build(BuildContext context) {
    print(this.id);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          InkWell(
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
                  Container(
                    padding: EdgeInsets.only(right: 24),
                    child: Text(
                      title,
                      style: TextStyles.gemTitle,
                    ),
                  ),
                  Space.custom(8),
                  Text(
                    displayUrl,
                    style: TextStyles.secondaryText,
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
          onLongPress != null
              ? Positioned(
                  right: 8,
                  top: 18,
                  child: GestureDetector(
                    onTap: onLongPress,
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.more_vert,
                        color: GemColors.blueGray.withAlpha(0xA0),
                        size: 24,
                      ),
                    ),
                  ),
                )
              : null,
        ].where((w) => w != null).toList(),
      ),
    );
  }
}

class GemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _color = Colors.black.withAlpha(0x8);
    final _secondColor = Colors.black.withAlpha(0x6);

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
