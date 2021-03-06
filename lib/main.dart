import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/receive_share_state.dart';
import 'dart:io' show Platform;
import 'package:sentry/sentry.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import 'package:Gem/screens/splash.dart';
import 'package:Gem/screens/add.dart';
import 'package:Gem/screens/portal.dart';
import 'package:Gem/screens/login_screen.dart';
import './screens/gems.dart';
import 'package:Gem/state/store.dart';
import 'package:Gem/services/gemServices.dart' show registerClient;
import 'package:Gem/styles.dart' show GemColors;

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
  if (kReleaseMode) {
    final SentryClient sentry = new SentryClient(
        dsn: "https://7b2c5fa087fc4c8cb89902fb9f1dc326@sentry.io/1551593");

    try {
      FlutterError.onError = (details, {bool forceReport = false}) {
        try {
          sentry.captureException(
            exception: details.exception,
            stackTrace: details.stack,
          );
        } catch (e) {
          print('Sending report to sentry.io failed: $e');
        } finally {
          FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
        }
      };

      registerStore();
      registerClient(client.value);
      runApp(GemApp());
    } catch (error, stackTrace) {
      sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  } else {
    registerStore();
    registerClient(client.value);
    runApp(GemApp());
  }
}

class GemApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GemAppState();
}

class _GemAppState extends ReceiveShareState<GemApp> {
  @override
  void receiveShare(share) async {
    // SharedPreferences storage = await SharedPreferences.getInstance();

    // final session = storage.getString('session');
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
    if (Platform.isAndroid) enableShareReceiving();
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
          '/portal': (BuildContext context) => Portal(),
        },
        home: Splash(),
      ),
    );
  }
}
