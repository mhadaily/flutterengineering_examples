import '../../models/models.dart';

abstract interface class ContentInterface {
  Stream<List<PostDataModel>> getFeeds(List<String> userIds);
  Future<List<PostDataModel>> getUserPosts(String userId);
}
