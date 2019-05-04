import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles.dart' show TextStyles, Space;

class Gem extends StatelessWidget {
  final String title;
  final String href;
  final String displayUrl;

  Gem({this.title, this.href, this.displayUrl});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          launch(href);
        },
        splashColor: Colors.black.withAlpha(0x08),
        highlightColor: Colors.black.withAlpha(0x05),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Space.sml,
              Text(
                title,
                style: TextStyles.gemTitle,
              ),
              Space.custom(8),
              Text(
                displayUrl,
                style: TextStyles.secondaryText,
              ),
              Space.sml,
              Container(height: 1, color: Color(0xFFEEEEEE)),
            ],
          ),
        ),
      ),
    );
  }
}
