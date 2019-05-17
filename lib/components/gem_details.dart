import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';

import 'package:Gem/styles.dart';
import 'package:Gem/state/store.dart';
import 'package:Gem/components/gem.dart';

class GemDetails extends StatefulWidget {
  final Map gem;
  final Function deleteGem;
  final int index;
  final Function toggleFavorite;
  final Function(Flushbar bar) showSnackbar;

  GemDetails({
    this.gem,
    this.index,
    this.deleteGem,
    this.toggleFavorite,
    this.showSnackbar,
  });

  @override
  createState() => _GemDetailsState();
}

class _GemDetailsState extends State<GemDetails>
    with SingleTickerProviderStateMixin {
  bool _showFolders = false;

  _showSnackbar(String message, {Function onPressed, String actionText}) {
    widget.showSnackbar(Flushbar(
      message: message,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(0x1F),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      mainButton: onPressed != null
          ? FlatButton(
              onPressed: onPressed,
              child: Text(
                actionText,
                style: TextStyle(color: GemColors.amber),
              ),
            )
          : null,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 500),
      aroundPadding: EdgeInsets.all(12),
      borderRadius: 6,
      backgroundColor: GemColors.text,
    ));
  }

  _toggleFolders() {
    setState(() {
      _showFolders = !_showFolders;
    });
  }

  Map<String, dynamic> _getFolder() {
    return getStore()
        .current
        .folders
        .firstWhere((f) => f['id'] == widget.gem['folderId']);
  }

  Widget _buildMenu() {
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(Icons.content_copy),
            title: Text(
              'Copy link',
              style: TextStyles.gemTitle,
            ),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: widget.gem['href']));
              Navigator.pop(context);
              _showSnackbar("Link copied to clipboard");
            },
          ),
          ListTile(
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
          ListTile(
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
                Navigator.pop(context);
                _showSnackbar(
                  widget.gem['favorite']
                      ? "Gem added to favorites"
                      : "Gem removed from favorites",
                );
              });
            },
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(Icons.folder_open),
            // enabled: false,
            title: Text(
              widget.gem['folderId'] != null
                  ? 'Move from ${_getFolder()['title']}'
                  : 'Move to folder',
              style: TextStyles.gemTitle,
            ),
            onTap: () {
              _toggleFolders();
            },
          ),
          ListTile(
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
                Navigator.pop(context);
                _showSnackbar(
                  'Removed Gem',
                  actionText: "UNDO",
                  onPressed: () {
                    getStore().undoDeleteGem(
                        widget.gem['id'], widget.index, widget.gem, () {
                      _showSnackbar('Gem restored');
                    });
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFolders() {
    List<Widget> folders = getStore()
        .current
        .folders
        .where((f) => f['id'] != widget.gem['folderId'])
        .map(
          (f) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 28),
                leading: Icon(Icons.folder_open),
                title: Text(
                  f['title'],
                  style: TextStyles.gemTitle,
                ),
                onTap: () {
                  getStore().moveGem(widget.gem['id'], f['id'], () {
                    Navigator.pop(context);
                    _showSnackbar("Gem moved to ${f['title']}");
                  });
                },
              ),
        )
        .toList();

    if (widget.gem['folderId'] != null) {
      final String folderTitle = _getFolder()['title'];
      folders = [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 28),
          leading: Icon(Icons.remove_circle_outline),
          title: Text(
            "Remove from $folderTitle",
            style: TextStyles.gemTitle,
          ),
          onTap: () {
            getStore().moveGem(widget.gem['id'], null, () {
              Navigator.pop(context);
              _showSnackbar(
                "Gem removed from $folderTitle",
              );
            });
          },
        ),
      ]..addAll(folders);
    }

    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(Icons.arrow_back),
            // enabled: false,
            title: Text(
              'Back',
              style: TextStyles.gemTitle,
            ),
            onTap: () {
              _toggleFolders();
            },
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(Icons.create_new_folder),
            // enabled: false,
            title: Text(
              'New folder',
              style: TextStyles.gemTitle,
            ),
            onTap: () {
              _toggleFolders();
            },
          ),
        ]..addAll(folders),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
            _showFolders ? _buildFolders() : _buildMenu(),
          ],
        ),
      ),
    );
  }
}
