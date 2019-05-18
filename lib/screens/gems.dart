import 'package:flutter/material.dart' hide TabBar;
import 'package:share/receive_share_state.dart';
import 'dart:io' show Platform;

import 'package:Gem/components/tabbar.dart';
import 'package:Gem/components/gem-list.dart';
import 'package:Gem/state/store.dart';
import 'package:Gem/screens/add.dart';

class Gems extends StatefulWidget {
  createState() => _GemsState();
}

class _GemsState extends ReceiveShareState<Gems>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  int _tabIndex = 0;
  int _favorites = 0;

  _onTabChange(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(),
        ),
      );
      return;
    }

    setState(() {
      _favorites = index;
    });
  }

  _onPageChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  void receiveShare(share) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(url: share.text),
        ));
  }

  @override
  void initState() {
    if (Platform.isAndroid) enableShareReceiving();
    getStore().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  onPageChanged: _onPageChanged,
                  controller: _pageController,
                  children: <Widget>[
                    GemList(
                      scaffoldKey: _scaffoldKey,
                      favorites: _favorites == 1,
                    ),
                  ],
                ),
              ),
              TabBar(
                  activeIndex: _tabIndex == 0 ? _favorites : 2,
                  onTap: _onTabChange),
            ],
          ),
        ),
      ),
    );
  }
}
