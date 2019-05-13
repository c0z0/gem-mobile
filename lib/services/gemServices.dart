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

Future createGem(String url) async {
  final client = _getClient();

  return await client.mutate(
    MutationOptions(
      document: _addGemMutation,
      variables: {'url': url},
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
