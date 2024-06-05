import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/domain/usecases/feed_usecase.dart';

final feedStateProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(feedUsecaseProvider).getFeed(),
);

final currentUserPostsProvider = FutureProvider.autoDispose(
  (ref) {
    final usecase = ref.watch(feedUsecaseProvider);
    return usecase.getCurrentUserPosts();
  },
);

final userPostsProvider = FutureProvider.autoDispose.family(
  (ref, String userId) {
    final usecase = ref.watch(feedUsecaseProvider);
    return usecase.getUserPosts(userId);
  },
);
