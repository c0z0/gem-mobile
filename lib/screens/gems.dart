import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/cupertino.dart';

import '../components/title_bar.dart';
import '../components/toolbar.dart';
import '../components/gem.dart';
import '../styles.dart';

final _viewerQuery = """
  query ViewerQuery {
    viewer {
      email
      gems {
        title
        displayUrl
        href
      }
    }
  }
""";

class Gems extends StatefulWidget {
  createState() => _GemsState();
}

class _GemsState extends State<Gems> {
  var searchQuery = '';

  _onSearchQueryChange(q) {
    setState(() {
      searchQuery = q;
    });
  }

  Widget _buildGems(gems) {
    final filteredGems = gems
        .where((g) =>
            g['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            g['displayUrl'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredGems.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) return Text('My Gems', style: TextStyles.h1);
          if (index == 1) return Space.sml;

          final g = filteredGems[index - 2];
          return Gem(
            displayUrl: g['displayUrl'],
            href: g['href'],
            title: g['title'],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Query(
            options: QueryOptions(document: _viewerQuery),
            builder: (QueryResult result, {VoidCallback refetch}) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleBar(),
                    Space.custom(12),
                    Toolbar(onSearchQueryChange: _onSearchQueryChange),
                    Container(height: 1, color: Color(0xFFEEEEEE)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12)
                            .add(EdgeInsets.only(top: 32)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            result.loading
                                ? Row(
                                    children: [
                                        CupertinoActivityIndicator(
                                          radius: 16,
                                        )
                                      ],
                                    mainAxisAlignment: MainAxisAlignment.center)
                                : _buildGems(result.data['viewer']['gems'])
                          ].where((t) => t != null).toList(),
                        ),
                      ),
                    ),
                  ]);
            },
          ),
        ),
      ),
    );
  }
}
