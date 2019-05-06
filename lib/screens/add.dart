import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/navbar.dart';
import '../components/input.dart';
import '../components/button.dart';
import '../styles.dart';

final _addGemMutation = """
mutation AddGem(\$url: String!) {
  createGem(url: \$url, tags: [], favorite: false) {
    title
    displayUrl
    id
    folderId
    favorite
    href
    tags
  }
}
""";

class AddScreen extends StatefulWidget {
  createState() => _AddScreenState();
}

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 48,
);

class _AddScreenState extends State<AddScreen> {
  String _url = '';

  _onUrlChange(s) {
    setState(() {
      _url = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: _addGemMutation,
      ),
      onCompleted: (res) {
        Navigator.of(context).pop();
      },
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
          body: Container(
            padding:
                EdgeInsets.only(top: NavBar.height - 64, left: 12, right: 12),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(tag: 'diamond', child: _diamond),
                  Space.lrg,
                  Text('Add a gem', style: TextStyles.h1),
                  Space.lrg,
                  Text('Link:', style: TextStyles.secondaryText),
                  Space.custom(8),
                  Row(children: <Widget>[
                    Expanded(
                        child: Input(
                      enabled: true,
                      autoFocus: true,
                      onChanged: _onUrlChange,
                      hintText: 'example.com',
                    )),
                  ]),
                  Space.med,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      PrimaryButton(
                        onPressed: () {
                          runMutation({'url': _url});
                        },
                        text: result.loading ? 'Loading...' : 'Add gem',
                        disabled: _url.length == 0 || result.loading,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: <Widget>[
                            // Icon(
                            //   Icons.arrow_back,
                            //   size: 16,
                            // ),
                            HorSpace.sml,
                            Text(
                              'CANCEL',
                              style: TextStyle(color: GemColors.text),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Space.sml,
                  result.errors != null
                      ? Text('Something went wrong', style: TextStyles.error)
                      : null,
                ].where((w) => w != null).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
