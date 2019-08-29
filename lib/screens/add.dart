import 'package:Gem/components/create_folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

import 'package:Gem/components/navbar.dart';
import 'package:Gem/components/input.dart';
import 'package:Gem/components/button.dart';
import 'package:Gem/styles.dart';
import 'package:Gem/state/store.dart';

class AddScreen extends StatefulWidget {
  final String url;

  createState() => _AddScreenState(sharedUrl: this.url);

  AddScreen({this.url: ''});
}

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 48,
);

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller;

  String _url;
  String _selectedFolderId;
  String sharedUrl;

  _AddScreenState({this.sharedUrl});

  @override
  void initState() {
    _controller = TextEditingController(text: sharedUrl);
    _url = sharedUrl;

    _controller.addListener(_onUrlChange);

    // _animationController.forward();
    super.initState();
  }

  _onUrlChange() {
    setState(() {
      _url = _controller.text;
    });
  }

  _onFolderChange(String id) {
    setState(() {
      _selectedFolderId = id;
    });
  }

  Map<String, dynamic> _getFolder() {
    if (_selectedFolderId == null) return {'id': null, 'title': 'No folder'};
    return getStore()
        .current
        .folders
        .firstWhere((f) => f['id'] == _selectedFolderId);
  }

  _showFolders() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => FolderSelector(
              onFolderSelected: _onFolderChange,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GemsStoreConsumer(
      builder: (BuildContext context, GemsData data, GemsStore store) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding:
                EdgeInsets.only(top: NavBar.height - 64, left: 12, right: 12),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(tag: 'diamond', child: _diamond),
                  Space.lrg,
                  Text('Add a gem', style: TextStyles.h1),
                  Space.lrg,
                  Text('Link:', style: TextStyles.secondaryText),
                  Space.custom(8),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 48,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: -12,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Input(
                                controller: _controller,
                                enabled: true,
                                autoFocus: true,
                                hintText: 'example.com',
                              ),
                            ),
                            IconButton(
                              color: GemColors.purple,
                              icon: Icon(
                                Icons.content_paste,
                                color: GemColors.blueGray,
                              ),
                              onPressed: () async {
                                ClipboardData data =
                                    await Clipboard.getData('text/plain');
                                _controller.text = data.text;
                                _controller.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: data.text.length);
                                // _onUrlChange(data.text);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Space.sml,
                  Text('Folder:', style: TextStyles.secondaryText),
                  Space.custom(8),
                  Material(
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        onTap: _showFolders,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.folder_open,
                                color: GemColors.blueGray,
                              ),
                              HorSpace.sml,
                              Text(
                                _getFolder()['title'] ?? 'No folder',
                                style: TextStyles.gemTitle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Space.med,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        onPressed: () {
                          store.createGem(_url, _selectedFolderId, () {
                            Navigator.pop(context);
                          });
                        },
                        text: data.createLoading ? 'Loading...' : 'Add gem',
                        disabled: _url.length == 0 || data.createLoading,
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CANCEL',
                            textAlign: TextAlign.end,
                            style: TextStyle(color: GemColors.text),
                          ))
                    ],
                  ),
                  Space.sml,
                  data.createError
                      ? Text('Something went wrong', style: TextStyles.error)
                      : null,
                ].where((w) => w != null).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FolderSelector extends StatefulWidget {
  final Function(String id) onFolderSelected;

  FolderSelector({this.onFolderSelected});
  @override
  createState() => _FolderSelectorState();
}

class _FolderSelectorState extends State<FolderSelector> {
  bool _showCreateFolder = false;

  _toggleCreateFolder() {
    setState(() {
      _showCreateFolder = !_showCreateFolder;
    });
  }

  Widget _buildFolders(BuildContext context) {
    List<dynamic> folders = getStore().current.folders;

    List<Widget> builtFolders = folders
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
                  widget.onFolderSelected(f['id']);
                  Navigator.pop(context);
                },
              ),
        )
        .toList();

    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
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
              _toggleCreateFolder();
            },
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 28),
            leading: Icon(Icons.remove),
            title: Text(
              'No folder',
              style: TextStyles.gemTitle,
            ),
            onTap: () {
              widget.onFolderSelected(null);
              Navigator.pop(context);
            },
          ),
        ]..addAll(builtFolders),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showCreateFolder)
      return CreateFolder(
        onCancel: _toggleCreateFolder,
        onCreate: (Map<String, dynamic> folder) {
          widget.onFolderSelected(folder['id']);
          Navigator.pop(context);
        },
      );

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 36, left: 28, right: 28),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Select folder', style: TextStyles.h1),
                    Space.med,
                  ],
                ),
              ),
              _buildFolders(context),
            ],
          ),
        ),
      ),
    );
  }
}
