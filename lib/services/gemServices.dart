import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final _viewerQuery = """
  query ViewerQuery {
    viewer {
      __typename
      email
      gems {
        title
        displayUrl
        id
        folderId
        favorite
        href
        tags
      }
      folders {
        id
        title
      }
    }
  }
""";

final getIt = GetIt();

registerClient(GraphQLClient client) {
  getIt.registerSingleton<GraphQLClient>(client);
}

GraphQLClient _getClient() {
  return getIt.get<GraphQLClient>();
}

// final _checkSessionQuery = """
//   query checkSession {
//     viewer {
//       __typename
//       id
//     }
//   }
// """;

Future<bool> checkSession() async {
  // final client = _getClient();

  // final res = await client.query(
  //   QueryOptions(
  //     document: _checkSessionQuery,
  //     fetchPolicy: FetchPolicy.networkOnly,
  //   ),
  // );

  await Future.delayed(Duration(milliseconds: 500));

  return true;
}

Future fetchViewer() async {
  final client = _getClient();

  return await client.query(
    QueryOptions(
      document: _viewerQuery,
      fetchPolicy: FetchPolicy.networkOnly,
    ),
  );
}

clearCache() {
  final client = _getClient();

  client.cache.reset();
}

final _addGemMutation = """
mutation AddGem(\$url: String!, \$folderId: ID) {
  createGem(url: \$url, tags: [], favorite: false, folderId: \$folderId) {
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

Future createGem(String url, String folderId) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _addGemMutation,
      variables: {'url': url, 'folderId': folderId},
    ),
  );
}

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

Future deleteGem(String id) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _deleteGemMutation,
      variables: {'id': id},
    ),
  );
}

final _toggleFavoriteMutation = """
  mutation ToggleFavorite(\$id: ID!) {
      toggleFavoriteGem(id: \$id) {
        id
        favorite
      }
    }
""";

Future toggleFavorite(String id) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _toggleFavoriteMutation,
      variables: {'id': id},
    ),
  );
}

final _moveGemMutation = """
 mutation MoveGem(\$id: ID!, \$folderId: ID) {
    moveGem(id: \$id, folderId: \$folderId) {
      id
      folderId
    }
  }
""";

Future moveGem(String id, String folderId) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _moveGemMutation,
      variables: {'id': id, 'folderId': folderId},
    ),
  );
}

final _undoDeleteGemMutation = """
  mutation UndoDeleteGem(\$id: ID!) {
    undoDeleteGem(id: \$id) {
        id
    }
  }
""";

Future undoDeleteGem(String id) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _undoDeleteGemMutation,
      variables: {'id': id},
    ),
  );
}

final _createFolderMutation = """
  mutation createFolder(\$title: String!) {
    createFolder(title: \$title) {
      title
      id
    }
  }
""";

Future createFolder(String title) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _createFolderMutation,
      variables: {'title': title},
    ),
  );
}
