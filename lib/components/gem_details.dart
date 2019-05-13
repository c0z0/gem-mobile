import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

import '../styles.dart';
import './gem.dart';

class GemDetails extends StatefulWidget {
  final Map gem;
  final Function deleteGem;
  final Function toggleFavorite;
  final GlobalKey<ScaffoldState> scaffoldKey;

  GemDetails({
    this.gem,
    this.deleteGem,
    this.toggleFavorite,
    this.scaffoldKey,
  });

  @override
  createState() => _GemDetailsState();
}

class _GemDetailsState extends State<GemDetails>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 36, left: 28, right: 28),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Gem details', style: TextStyles.h1),
                Space.med,
                Gem(
                  id: widget.gem['id'],
                  displayUrl: widget.gem['displayUrl'],
                  href: widget.gem['href'],
                  favorite: widget.gem['favorite'],
                  title: widget.gem['title'],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Material(
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    leading: Icon(Icons.content_copy),
                    title: Text(
                      'Copy link',
                      style: TextStyles.gemTitle,
                    ),
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.gem['href']));
                      widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text("Link copied to clipboard"),
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    leading: Icon(Icons.share),
                    title: Text(
                      'Share link',
                      style: TextStyles.gemTitle,
                    ),
                    onTap: () async {
                      Share.plainText(text: widget.gem['href']).share();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    leading: Icon(Icons.star),
                    // enabled: false,
                    title: Text(
                      widget.gem['favorite']
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      style: TextStyles.gemTitle,
                    ),
                    onTap: () {
                      widget.toggleFavorite(widget.gem['id'], () {
                        widget.scaffoldKey.currentState
                            .showSnackBar(new SnackBar(
                          content: new Text(widget.gem['favorite']
                              ? "Gem added to favorites"
                              : "Gem removed from favorites"),
                        ));
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Material(
                  color: Colors.white,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    leading: Icon(Icons.delete_forever),
                    // enabled: false,
                    title: Text(
                      'Delete',
                      style: TextStyles.gemTitle,
                    ),
                    onTap: () {
                      widget.deleteGem(widget.gem['id'], () {
                        widget.scaffoldKey.currentState
                            .showSnackBar(new SnackBar(
                          content: new Text("Gem deleted"),
                        ));
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
