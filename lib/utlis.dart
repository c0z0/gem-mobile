import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

bool showed = false;

void checkForUpdate(BuildContext context) async {
  if (!Platform.isAndroid || showed) return;

  String buildNumber = (await PackageInfo.fromPlatform()).buildNumber;
  final response = await http.get("https://app.gem.cserdean.com/info");

  if (response.statusCode != 200) return;

  Map<String, dynamic> data = json.decode(response.body);

  String latestVersion = data['latestVersion'].toString();

  showed = true;

  if (buildNumber != latestVersion)
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Update available'),
            actions: <Widget>[
              FlatButton(
                child: Text('LATER'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('INSTALL'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _installUpdate();
                },
              ),
            ],
          );
        });
}

void _installUpdate() async {
  launch('https://app.gem.cserdean.com/',
      option: CustomTabsOption(
        toolbarColor: Colors.white,
      ));
}
