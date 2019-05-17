import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/receive_share_state.dart';

import 'package:Gem/screens/add.dart';

// import '../styles.dart' show TextStyles, Space;

// final _diamond = SvgPicture.asset(
//   'assets/diamond.svg',
//   width: 64,
// );

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends ReceiveShareState<Splash> {
  _checkLogin(BuildContext context) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final session = storage.getString('session');

    if (session == null)
      return Navigator.of(context).pushReplacementNamed('/login');

    Navigator.of(context).pushReplacementNamed('/gems');
  }

  @override
  void receiveShare(share) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final session = storage.getString('session');

    // if (session == null)
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(url: share.text),
        ));
  }

  @override
  void initState() {
    // _animationController.forward();
    _checkLogin(context);
    enableShareReceiving();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 48, right: 48, top: 192),
        color: Colors.white,
        // child: Row(
        //   children: <Widget>[
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         _diamond,
        //         Space.lrg,
        //         Text(
        //           'Gem',
        //           style: TextStyles.title,
        //         ),
        //         Text(
        //           'Keep your online finds',
        //           style: TextStyles.subtitle,
        //         )
        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }
}
