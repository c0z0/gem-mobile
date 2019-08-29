import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

void checkForUpdate(BuildContext context) async {
  String buildNumber = (await PackageInfo.fromPlatform()).buildNumber;
  final response = await http.get("https://app.gem.cserdean.com/info");

  if (response.statusCode != 200) return;

  Map<String, dynamic> data = json.decode(response.body);

  String latestVersion = data['latestVersion'].toString();

  if (buildNumber != latestVersion || true)
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
                onPressed: () {},
              ),
            ],
          );
        });
}
