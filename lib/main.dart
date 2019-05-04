import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/splash.dart';
import './screens/login_screen.dart';
import './screens/gems.dart';

import './styles.dart' show GemColors;

void main() {
  runApp(GemApp());
}

class GemApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SanFrancisco',
          accentColor: GemColors.purple,
          accentColorBrightness: Brightness.light,
        ),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginScreen(),
          '/gems': (BuildContext context) => Gems(),
        },
        home: Splash(),
      ),
    );
  }
}
