import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef RefetchCallback({bool resetCache});

class CustomQuery extends StatefulWidget {
  final Widget Function(QueryResult result, RefetchCallback refetch) builder;
  final QueryOptions options;
  final Map<String, dynamic> variables;

  CustomQuery({this.builder, this.variables, this.options});

  @override
  State<StatefulWidget> createState() => _CustomQueryState();
}

class _CustomQueryState extends State<CustomQuery> {
  QueryResult _result = QueryResult(loading: true);
  GraphQLClient _client;
  bool _initiated = false;

  _initialQuery() async {
    if (!_initiated) {
      _initiated = true;
      final QueryResult newResult = await _client.query(widget.options);
      setState(() {
        _result = newResult;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
    _initialQuery();
  }

  Future pause(Duration d) => new Future.delayed(d);

  _onRefetch({bool resetCache: true}) async {

    if (resetCache) _client.cache.reset();

    // _client.watchQuery(widget.options).onData([(res) {}]);

    setState(() {
      _result = QueryResult(loading: true, data: _result.data);
    });

    final QueryResult newResult = await _client.query(widget.options);

    setState(() {
      _result = newResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_result, _onRefetch);
  }
}
