import 'package:Gem/components/gem_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/navbar.dart';
import '../components/gem.dart';
import '../styles.dart';

final _viewerQuery = """
  query ViewerQuery {
    viewer {
      email
      gems {
        title
        displayUrl
        id
        folderId
        favorite
        href
        tags
      }
    }
  }
""";

class Gems extends StatefulWidget {
  createState() => _GemsState();
}

class _GemsState extends State<Gems> {
  String searchQuery = '';

  final scrollController = ScrollController();

  _showDetails(gem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GemDetails(
              gem: gem,
            )));
  }

  _onSearchQueryChange(q) {
    setState(() {
      searchQuery = q;
    });
  }

  Widget _buildGems(List gems, bool loading) {
    final filteredGems = gems
        .where((g) =>
            g['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            g['displayUrl'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.only(top: 32 + NavBar.height),
      itemCount: loading ? 7 : filteredGems.length + 1,
      controller: scrollController,
      physics: loading ? NeverScrollableScrollPhysics() : null,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('My Gems', style: TextStyles.h1),
                Space.sml,
              ],
            ),
          );

        if (loading) return GemPlaceholder();

        final g = filteredGems[index - 1];
        return Gem(
          onLongPress: () {
            _showDetails(g);
          },
          displayUrl: g['displayUrl'],
          id: g['id'],
          href: g['href'],
          title: g['title'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Query(
            options: QueryOptions(
              document: _viewerQuery,
              pollInterval: 10,
            ),
            builder: (QueryResult result, {VoidCallback refetch}) {
              if (result.errors != null) {
                print(result.errors);
                return Text('error...');
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(),
                        Positioned.fill(
                          child: _buildGems(
                              result.loading
                                  ? []
                                  : result.data['viewer']['gems'],
                              result.loading),
                        ),
                        NavBar(
                          controller: scrollController,
                          onSearchQueryChange: _onSearchQueryChange,
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: GemColors.border),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showDetails(null);
                          },
                          child: Icon(
                            Icons.home,
                            size: 28,
                            color: GemColors.purple,
                          ),
                        ),
                        Icon(
                          Icons.star_border,
                          size: 28,
                          color: GemColors.blueGray,
                        ),
                        Icon(
                          Icons.menu,
                          size: 28,
                          color: GemColors.blueGray,
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
