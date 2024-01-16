import 'dart:convert';

import '../data_sources/remote.dart';
import '../models/model.dart';

class DataRepository {
  // Placeholder for a data source, e.g., database or network API
  DataRepository(this.remote);

  final RemoteService remote;

  Future<List<UserModel>> fetchData() async {
    final data = await remote.getRemoteData();
    final json = jsonDecode(data) as List<dynamic>;
    return json.map((e) => UserModel.fromJson(e)).toList();
  }
}
