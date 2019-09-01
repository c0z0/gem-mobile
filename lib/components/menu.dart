import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:package_info/package_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:Gem/state/store.dart';
import 'package:Gem/styles.dart';
import 'package:Gem/components/spinning_diamond.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String _buildNumber = "";
  int _showBuildNumberTaps = 0;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((data) {
      setState(() {
        _buildNumber = data.buildNumber;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GemsStoreConsumer(
        builder: (BuildContext context, GemsData data, GemsStore store) {
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 2,
                  top: 16,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: GemColors.blueGray,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 48, right: 48, bottom: 48),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SpinningDiamond(
                                constantSpeed: .5,
                              ),
                              Space.med,
                              Text('Gem', style: TextStyles.title),
                              Text('keep your online finds',
                                  style: TextStyles.subtitle),
                              Space.sml,
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Built by ',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              _showBuildNumberTaps =
                                                  (_showBuildNumberTaps + 1) %
                                                      6;
                                            });
                                          }),
                                    TextSpan(
                                      text: 'cserdean.com',
                                      style: TextStyles.secondaryText.apply(
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('https://cserdean.com',
                                              option: CustomTabsOption(
                                                toolbarColor: Colors.white,
                                                showPageTitle: true,
                                                enableDefaultShare: true,
                                              ));
                                        },
                                    ),
                                  ],
                                  style: TextStyles.secondaryText,
                                ),
                              ),
                              Space.sml,
                              Opacity(
                                opacity: _showBuildNumberTaps < 3 ? 0 : 1,
                                child: Text(
                                  'Build number: $_buildNumber',
                                  style: TextStyles.secondaryText,
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Portal',
                                style: TextStyles.gemTitle,
                              ),
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed('/portal'),
                            ),
                            ListTile(
                              leading: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      data.loading ? '' : data.viewerAvatar,
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              dense: true,
                              title: Text(
                                data.loading
                                    ? 'Loading...'
                                    : 'Logged in as ${data.viewerEmail}.',
                                style: TextStyles.secondaryText,
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                'Logout',
                                style: TextStyles.gemTitle,
                              ),
                              onTap: () async {
                                SharedPreferences storage =
                                    await SharedPreferences.getInstance();

                                storage.remove('session');

                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                                store.clear();
                              },
                            ),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
