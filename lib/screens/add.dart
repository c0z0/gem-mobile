import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

import '../components/navbar.dart';
import '../components/input.dart';
import '../components/button.dart';
import '../styles.dart';
import '../state/store.dart';

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

  @override
  Widget build(BuildContext context) {
    return GemsStoreConsumer(
      builder: (BuildContext context, GemsData data, GemsStore store) {
        return Scaffold(
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
                                color: GemColors.text,
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
                  Space.med,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        onPressed: () {
                          store.createGem(_url, () {
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
