import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:Gem/services/gemServices.dart' as services;

GetIt _getIt = new GetIt();

class GemsData {
  List folders;
  List gems;
  bool loading;
  bool fetched;
  bool createLoading;
  bool createError;
  String viewerEmail;
  int deletedIndex;
  bool error;

  GemsData({
    this.folders,
    this.deletedIndex,
    this.viewerEmail,
    this.gems,
    this.loading: true,
    this.error: false,
    this.fetched: false,
    this.createLoading: false,
    this.createError: false,
  });
}

class GemsStore {
  BehaviorSubject _data = BehaviorSubject.seeded(GemsData());

  Observable get stream$ => _data.stream;
  GemsData get current => _data.value;

  GemsData _cloneData() {
    return GemsData(
      folders: _data.value.folders,
      gems: _data.value.gems,
      deletedIndex: _data.value.deletedIndex,
      viewerEmail: _data.value.viewerEmail,
      error: _data.value.error,
      loading: _data.value.loading,
      fetched: _data.value.fetched,
      createLoading: _data.value.createLoading,
      createError: _data.value.createError,
    );
  }

  _setLoading() {
    final newData = _cloneData();

    newData.loading = true;
    newData.error = false;

    _data.add(newData);
  }

  _setCreateLoading() {
    final newData = _cloneData();

    newData.createLoading = true;
    newData.createError = false;

    _data.add(newData);
  }

  createGem(String url, String folderId, Function success) async {
    _setCreateLoading();

    try {
      Map result = (await services.createGem(url, folderId)).data;
      Map newGem = result['createGem'];

      final _newData = _cloneData();
      _newData.gems.insert(0, newGem);
      _newData.createLoading = false;

      _data.add(_newData);

      success();
    } catch (err) {
      print(err);

      final _newData = _cloneData();
      _newData.createLoading = false;
      _newData.createError = true;

      _data.add(_newData);
    }
  }

  createFolder(String title, Function success) async {
    try {
      Map result = (await services.createFolder(title)).data;
      Map newFolder = result['createFolder'];

      final _newData = _cloneData();
      _newData.folders.insert(0, newFolder);

      _data.add(_newData);

      success(newFolder);
    } catch (err) {
      print(err);

      final _newData = _cloneData();
      _newData.createLoading = false;
      _newData.createError = true;

      _data.add(_newData);
    }
  }

  deleteGem(String id, Function success) async {
    services.deleteGem(id);

    final _newData = _cloneData();
    _newData.deletedIndex = _newData.gems.indexWhere((g) => g['id'] == id);
    _newData.gems = _newData.gems.where((g) => g['id'] != id).toList();

    _data.add(_newData);
    success();
  }

  undoDeleteGem(String id, int index, dynamic gem, Function success) async {
    services.undoDeleteGem(id);

    final _newData = _cloneData();
    _newData.gems = _newData.gems..insert(_newData.deletedIndex, gem);

    _data.add(_newData);
    success();
  }

  moveGem(String id, String folderId, Function success) async {
    services.moveGem(id, folderId);

    final _newData = _cloneData();
    _newData.gems = _newData.gems.map((g) {
      if (g['id'] != id) return g;
      g['folderId'] = folderId;
      return g;
    }).toList();

    _data.add(_newData);
    success();
  }

  toggleFavorite(String id, Function success) async {
    services.toggleFavorite(id);

    final _newData = _cloneData();
    _newData.gems = _newData.gems.map((g) {
      if (g['id'] != id) return g;
      g['favorite'] = !g['favorite'];
      return g;
    }).toList();

    _data.add(_newData);
    success();
  }

  clear() {
    final _newData = GemsData();

    services.clearCache();

    _data.add(_newData);
  }

  fetch() async {
    _setLoading();

    try {
      var res = await services.fetchViewer();

      Map result = res.data['viewer'];

      List gems = result['gems'];
      List folders = result['folders'];

      final _newData = _cloneData();
      _newData.gems = gems;
      _newData.viewerEmail = res.data['viewer']['email'];
      _newData.folders = folders;
      _newData.fetched = true;
      _newData.loading = false;

      _data.add(_newData);
    } catch (err) {
      print(err);

      final _newData = _cloneData();
      _newData.loading = false;
      _newData.error = true;

      _data.add(_newData);
    }
  }
}

GemsStore getStore() {
  return _getIt.get<GemsStore>();
}

void registerStore() {
  _getIt.registerSingleton<GemsStore>(GemsStore());
}

class GemsStoreConsumer extends StatelessWidget {
  final Widget Function(BuildContext context, GemsData current, GemsStore store)
      builder;
  final GemsStore _store = _getIt.get<GemsStore>();

  GemsStoreConsumer({
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _store.stream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          return builder(context, _store.current, _store);
        });
  }
}
