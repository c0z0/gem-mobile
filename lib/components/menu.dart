import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:Gem/state/store.dart';
import 'package:Gem/styles.dart';

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 64,
);

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GemsStoreConsumer(
        builder: (BuildContext context, GemsData data, GemsStore store) {
          return Container(
            padding: EdgeInsets.only(left: 48, right: 48, bottom: 48),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(tag: 'diamond', child: _diamond),
                        Space.med,
                        Text('Gem', style: TextStyles.title),
                        Text('keep your online finds',
                            style: TextStyles.subtitle),
                        Space.sml,
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Built by '),
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
                                    }),
                            ],
                            style: TextStyles.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        dense: true,
                        title: Text(
                          data.loading
                              ? 'Loading...'
                              : 'Logged in as ${data.viewerEmail}.',
                          style: TextStyles.gemTitle,
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

                          Navigator.of(context).pushReplacementNamed('/login');
                          store.clear();
                        },
                      ),
                    ],
                  ),
                ]),
          );
        },
      ),
    );
  }
}
