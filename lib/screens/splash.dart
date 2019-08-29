import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/receive_share_state.dart';

import 'package:Gem/screens/add.dart';
import 'package:Gem/services/gemServices.dart' show checkSession;
import 'package:Gem/components/spinning_diamond.dart' show SpinningDiamond;

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

    if (!(await checkSession())) {
      await storage.remove('session');
      return Navigator.of(context).pushReplacementNamed('/login');
    }

    Navigator.of(context).pushReplacementNamed('/gems');
  }

  @override
  void receiveShare(share) async {
    // SharedPreferences storage = await SharedPreferences.getInstance();
    // final session = storage.getString('session');

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
    if (Platform.isAndroid) enableShareReceiving();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Hero(
            child: SpinningDiamond(
              size: 128,
              constantSpeed: 1,
            ),
            tag: 'diamond',
          ),
        ),
      ),
    );
  }
}
