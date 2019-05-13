import 'package:flutter/material.dart' hide TabBar;
import 'package:share/receive_share_state.dart';

import '../components/tabbar.dart';
import '../components/gem-list.dart';
import '../components/menu.dart';
import '../state/store.dart';
import './add.dart';

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
    setState(() {
      _tabIndex = index == 2 ? 1 : 0;
      _favorites = index == 2 ? _favorites : index;
    });

    _pageController.animateToPage(index == 2 ? 1 : 0,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
    enableShareReceiving();
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
                    Menu(),
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
