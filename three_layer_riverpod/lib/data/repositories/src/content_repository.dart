import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data_sources/data_source.dart';
import '../../interfaces/interfaces.dart';
import '../../models/models.dart';

const _online = true;

class ContentRepository implements ContentInterface {
  ContentRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final ContentInterface localDataSource;
  final ContentInterface remoteDataSource;

  @override
  Stream<List<PostDataModel>> getFeeds(List<String> userIds) {
    if (_online) {
      return remoteDataSource.getFeeds(userIds);
    }

    return localDataSource.getFeeds(userIds);
  }

  @override
  Future<List<PostDataModel>> getUserPosts(String userId) {
    if (_online) {
      return remoteDataSource.getUserPosts(userId);
    }

    return localDataSource.getUserPosts(userId);
  }
}

// 3. Create a provider for the repository
final contentRepositoryProvider = Provider<ContentInterface>(
  (ref) => ContentRepository(
    localDataSource: ref.watch(contentLocalDataSourceProvider),
    remoteDataSource: ref.watch(contentRemoteDataSourceProvider),
  ),
);
