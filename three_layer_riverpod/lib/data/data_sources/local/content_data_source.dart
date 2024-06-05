import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/data/models/src/post.dart';

import '../../interfaces/interfaces.dart';

class ContentLocalDataSource implements ContentInterface {
  @override
  Stream<List<PostDataModel>> getFeeds(List<String> userIds) {
    // TODO: implement getFeeds
    throw UnimplementedError();
  }

  @override
  Future<List<PostDataModel>> getUserPosts(String userId) {
    // TODO: implement getUserPosts
    throw UnimplementedError();
  }
}

// 3. Create a provider for the data source
final contentLocalDataSourceProvider = Provider<ContentInterface>(
  (ref) => ContentLocalDataSource(),
);
