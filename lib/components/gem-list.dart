import 'package:Gem/components/gem_details.dart';
import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter/rendering.dart';

import '../components/navbar.dart';
import '../components/gem.dart';
import '../styles.dart';
import '../state/store.dart';

class GemList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool favorites;

  GemList({this.scaffoldKey, this.favorites});

  createState() => _GemListState();
}

class _GemListState extends State<GemList> {
  final scrollController = ScrollController();

  String _searchQuery = '';

  _onSearchQueryChange(q) {
    setState(() {
      _searchQuery = q;
    });
  }

  List<Widget> _buildFolders(List gems, List folders) {
    List<Widget> folderList = folders
        .map((f) => ExpansionTile(
              title: Text(f['title']),
              children: gems
                  .where((g) => g['folderId'] == f['id'])
                  .map((g) => Gem(
                        onLongPress: () {
                          _showGemDetails(
                            context,
                            g,
                            getStore().deleteGem,
                            getStore().toggleFavorite,
                          );
                        },
                        displayUrl: g['displayUrl'],
                        id: g['id'],
                        href: g['href'],
                        favorite: g['favorite'],
                        title: g['title'],
                      ))
                  .toList(),
            ))
        .toList();

    List<Widget> extraGems = gems
        .where((g) => g['folderId'] == null)
        .map((g) => Gem(
              onLongPress: () {
                _showGemDetails(
                  context,
                  g,
                  getStore().deleteGem,
                  getStore().toggleFavorite,
                );
              },
              displayUrl: g['displayUrl'],
              favorite: g['favorite'],
              id: g['id'],
              href: g['href'],
              title: g['title'],
            ))
        .toList();

    return []..addAll(folderList)..addAll(extraGems);
  }

  Widget _buildGems(List gems, List folders, bool loading, Function deleteGem) {
    final filteredGems = gems
        .where((g) =>
            g['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            g['displayUrl'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .where((g) => !widget.favorites || g['favorite'])
        .toList();

    final List<Widget> itemList = _buildFolders(filteredGems, folders);

    return RefreshIndicator(
      onRefresh: () async {
        await getStore().fetch();
      },
      child: ListView.builder(
        padding: EdgeInsets.only(top: 32 + NavBar.height),
        itemCount: loading ? 6 : itemList.length + 1,
        controller: scrollController,
        physics: loading ? NeverScrollableScrollPhysics() : null,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0)
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text((widget.favorites ? 'Favorite' : 'My') + ' Gems',
                      style: TextStyles.h1),
                  Space.sml,
                ],
              ),
            );

          if (loading) return GemPlaceholder();

          return itemList[index - 1];
        },
      ),
    );
  }

  void _showGemDetails(context, gem, deleteGem, toggleFavorite) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return GemDetails(
            gem: gem,
            scaffoldKey: widget.scaffoldKey,
            deleteGem: deleteGem,
            toggleFavorite: toggleFavorite,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GemsStoreConsumer(
      builder: (BuildContext context, GemsData data, GemsStore store) {
        if (data.error) {
          return Text('error...');
        }

        return Stack(
          children: <Widget>[
            Container(),
            Positioned.fill(
              child: _buildGems(
                data.loading ? [] : data.gems,
                data.loading ? [] : data.folders,
                data.loading,
                store.deleteGem,
              ),
            ),
            NavBar(
              controller: scrollController,
              onSearchQueryChange: _onSearchQueryChange,
            ),
          ],
        );
      },
    );
  }
}
