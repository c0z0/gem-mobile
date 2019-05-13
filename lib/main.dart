import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/receive_share_state.dart';

import './screens/splash.dart';
import './screens/add.dart';
import './screens/login_screen.dart';
import './screens/gems.dart';
import './state/store.dart';
import 'services/gemServices.dart' show registerClient;

import './styles.dart' show GemColors;

final httpLink = HttpLink(
  uri: 'https://gem.cserdean.com/api',
);

final authLink = AuthLink(
  getToken: () async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    final session = storage.getString('session');

    return session != null ? 'Bearer $session' : '';
  },
);

final link = authLink.concat(httpLink as Link);

final client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    cache: OptimisticCache(
      dataIdFromObject: typenameDataIdFromObject,
    ),
    link: link,
  ),
);

void main() {
  registerStore();
  registerClient(client.value);
  runApp(GemApp());
}

class GemApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GemAppState();
}

class _GemAppState extends ReceiveShareState<GemApp> {
  @override
  void receiveShare(share) async {
    SharedPreferences storage = await SharedPreferences.getInstance();

    final session = storage.getString('session');
    // if (session != null)
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(url: share.text),
        ));
  }

  @override
  void initState() {
    // _animationController.forward();
    enableShareReceiving();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SanFrancisco',
          accentColor: GemColors.purple,
          accentColorBrightness: Brightness.light,
        ),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginScreen(),
          '/add': (BuildContext context) => AddScreen(),
          '/gems': (BuildContext context) => Gems(),
        },
        home: Splash(),
      ),
    );
  }
}
