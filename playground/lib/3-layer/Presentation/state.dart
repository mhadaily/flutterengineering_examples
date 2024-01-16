import 'package:flutter/material.dart';
import 'package:playground/3-layer/Data/data_sources/remote.dart';
import 'package:playground/3-layer/Data/models/model.dart';
import 'package:playground/3-layer/Data/repositories/repository.dart';

class UiStateManager with ChangeNotifier {
  late List<UserModel> _value;
  List<UserModel> get value => _value;

  void getUsers() async {
    final data = await DataRepository(RemoteService()).fetchData();
    _value = data;
    notifyListeners();
  }
}
