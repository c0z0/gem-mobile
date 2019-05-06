import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../styles.dart';
import './gem.dart';
import '../components/navbar.dart';

final _diamond = SvgPicture.asset(
  'assets/diamond.svg',
  width: 48,
);

final _deleteGemMutation = """
  mutation DeleteGem(\$id: ID!) {
    deleteGem(id: \$id) {
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

class GemDetails extends StatefulWidget {
  final Map gem;
  final int index;
  final Function onClose;

  GemDetails({this.gem, this.index, this.onClose});

  @override
  createState() => _GemDetailsState();
}

class _GemDetailsState extends State<GemDetails>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: _deleteGemMutation,
        ),
        onCompleted: (res) {
          Navigator.of(context).pop();
        },
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                    top: NavBar.height - 64, left: 12, right: 12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(tag: 'diamond', child: _diamond),
                    Space.lrg,
                    Text('Gem details', style: TextStyles.h1),
                    Space.lrg,
                    Gem(
                      id: widget.gem['id'],
                      displayUrl: widget.gem['displayUrl'],
                      href: widget.gem['href'],
                      title: widget.gem['title'],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          textColor: Colors.red,
                          onPressed: () {
                            runMutation({'id': widget.gem['id']});
                          },
                          child: Text('DELETE'),
                        ),
                        FlatButton(
                          textColor: GemColors.text,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('BACK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
