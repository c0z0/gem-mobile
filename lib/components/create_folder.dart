import 'package:flutter/material.dart';

import 'package:Gem/styles.dart';
import 'package:Gem/components/button.dart';
import 'package:Gem/components/input.dart';
import 'package:Gem/state/store.dart';

class CreateFolder extends StatefulWidget {
  final Function(Map<String, dynamic> folder) onCreate;
  final Function onCancel;

  CreateFolder({
    this.onCreate,
    this.onCancel,
  });

  @override
  createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder>
    with SingleTickerProviderStateMixin {
  String _title = '';
  bool _loading = false;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '');

    _controller.addListener(_onTitleChange);

    // _animationController.forward();
    super.initState();
  }

  _onTitleChange() {
    setState(() {
      _title = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> hints = ['School', 'Gym', 'Design', 'Motivational']..shuffle();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                      Text('Create folder', style: TextStyles.h1),
                      Space.med,
                      Text('Link:', style: TextStyles.secondaryText),
                      Space.custom(8),
                      Input(
                        enabled: true,
                        controller: _controller,
                        autoFocus: true,
                        hintText: hints.first,
                      ),
                      Space.med,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          PrimaryButton(
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });

                              getStore().createFolder(_title,
                                  (Map<String, dynamic> folder) {
                                setState(() {
                                  _loading = false;
                                });
                                widget.onCreate(folder);
                              });
                            },
                            text: _loading ? 'Loading...' : 'Create folder',
                            disabled: _title.isEmpty || _loading,
                          ),
                          FlatButton(
                              onPressed: () {
                                widget.onCancel();
                              },
                              child: Text(
                                'CANCEL',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: GemColors.text),
                              ))
                        ],
                      ),
                      Space.med,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
