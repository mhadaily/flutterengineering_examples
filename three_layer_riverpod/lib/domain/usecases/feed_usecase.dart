import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../entities/post.dart';

abstract interface class FeedUsecase {
  Stream<List<Post>> getFeed();
  Future<List<Post>> getUserPosts(String userId);
  Future<List<Post>> getCurrentUserPosts();
}

class _FeedUsecase implements FeedUsecase {
  _FeedUsecase(
    this.authRepository,
    this.contentRepository,
  );

  final AuthInterface authRepository;
  final ContentInterface contentRepository;

  @override
  Stream<List<Post>> getFeed() {
    // authRepository.getCurrentUser();
    // authRepository.getUserFollowings();
    return contentRepository.getFeeds([]).map(
      (posts) => posts
          .map(
            (post) => Post.fromDataModel(post),
          )
          .toList(),
    );
  }

  @override
  Future<List<Post>> getCurrentUserPosts() {
    // final userId = authRepository.getCurrentUser();
    const userId = '1';
    return getUserPosts(userId);
  }

  @override
  Future<List<Post>> getUserPosts(String userId) {
    return contentRepository.getUserPosts(userId).then(
          (posts) => posts
              .map(
                (post) => Post.fromDataModel(post),
              )
              .toList(),
        );
  }
}

// 3. Create a provider for the use case
final feedUsecaseProvider = Provider<FeedUsecase>(
  (ref) => _FeedUsecase(
    ref.watch(authRepositoryProvider),
    ref.watch(contentRepositoryProvider),
  ),
);
