import 'package:Gem/components/gem_details.dart';
import 'package:flutter/material.dart' hide TabBar;
import 'package:flutter/rendering.dart';
import 'package:flushbar/flushbar.dart';

import 'package:Gem/components/navbar.dart';
import 'package:Gem/components/gem.dart';
import 'package:Gem/styles.dart';
import 'package:Gem/state/store.dart';
import 'package:Gem/services/gemServices.dart' show search;

class GemList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool favorites;

  GemList({this.scaffoldKey, this.favorites});

  createState() => _GemListState();
}

class _GemListState extends State<GemList> {
  final scrollController = ScrollController();

  String _searchQuery = '';
  List _searchResults = [];
  bool _searchLoading = false;

  _onSearchQueryChange(String q) async {
    if (q.length == 0) {
      setState(() {
        _searchQuery = q;
        _searchLoading = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searchQuery = q;
      _searchLoading = true;
    });

    _searchResults =
        (await search(q)).data['search'].map((r) => r['id']).toList();

    setState(() {
      _searchLoading = false;
    });
  }

  List<Widget> _buildFolders(List gems, List folders) {
    List<Widget> folderUpperList = folders
        .where((f) => gems.where((g) => g['folderId'] == f['id']).length > 0)
        .map((f) {
      final gemList = gems
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
          .toList();

      return ExpansionTile(
        initiallyExpanded: _searchQuery.length != 0 && gemList.length > 0,
        key: PageStorageKey<String>(f['id']),
        title: Text(
          f['title'],
          style: TextStyle(
            color: gemList.length > 0 ? GemColors.text : GemColors.blueGray,
          ),
        ),
        children: gemList,
      );
    }).toList();

    List<Widget> folderLowerList = folders
        .where((f) => gems.where((g) => g['folderId'] == f['id']).length == 0)
        .map((f) {
      final gemList = gems
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
          .toList();

      return ExpansionTile(
        initiallyExpanded: _searchQuery.length != 0 && gemList.length > 0,
        key: PageStorageKey<String>(f['id']),
        title: Text(
          f['title'],
          style: TextStyle(
            color: gemList.length > 0 ? GemColors.text : GemColors.blueGray,
          ),
        ),
        children: gemList,
      );
    }).toList();

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

    return []
      ..addAll(folderUpperList)
      ..add(folderUpperList.length > 0 ? Space.lrg : Space.custom(0))
      ..addAll(extraGems)
      ..add(folderLowerList.length > 0 ? Space.lrg : Space.custom(0))
      ..addAll(folderLowerList);
  }

  Widget _buildGems(List gems, List folders, bool loading, Function deleteGem) {
    final filteredGems = gems
        .where((g) =>
            (g['favorite'] || !widget.favorites) &&
            (_searchQuery.length == 0 || _searchResults.contains(g['id'])))
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
                  Text(
                      _searchQuery.length != 0
                          ? 'Search results'
                          : ((widget.favorites ? 'Favorite' : 'My') + ' Gems'),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext bc) {
          return GemDetails(
            gem: gem,
            showSnackbar: (Flushbar bar) {
              bar..show(context);
            },
            deleteGem: deleteGem,
            toggleFavorite: toggleFavorite,
            index:
                getStore().current.gems.indexWhere((g) => g['id'] == gem['id']),
          );
        },
      ),
    );
    return;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return GemDetails(
            gem: gem,
            showSnackbar: (Flushbar bar) {
              bar..show(context);
            },
            deleteGem: deleteGem,
            toggleFavorite: toggleFavorite,
            index:
                getStore().current.gems.indexWhere((g) => g['id'] == gem['id']),
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
                data.loading || _searchLoading,
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
