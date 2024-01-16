import '../Data/data.dart';

class UserBusinessLogic {
  final DataRepository repository;

  UserBusinessLogic(this.repository);

  Future<List<UserModel>> getUserData() {
    return repository.fetchData();
  }
}
