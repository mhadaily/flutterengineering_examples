import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/data/models/src/post.dart';

import '../../interfaces/interfaces.dart';

class ContentRemoteDataSource implements ContentInterface {
  const ContentRemoteDataSource(
      // this._httpClient,
      );

  // final HttpClient _httpClient;

  @override
  Stream<List<PostDataModel>> getFeeds(List<String> userIds) {
    // _httpClient.get()
    return Stream.value([]);
  }

  @override
  Future<List<PostDataModel>> getUserPosts(String userId) {
    return Future.value([]);
  }
}

// 3. Create a provider for the data source
final contentRemoteDataSourceProvider = Provider<ContentInterface>(
  (ref) => const ContentRemoteDataSource(),
);
