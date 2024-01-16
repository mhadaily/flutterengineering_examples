// Pure interface for a data fetching service
abstract interface class DataService {
  Future<String> fetchData();
}

// Implementation of DataService for fetching data from a network API
class NetworkDataService implements DataService {
  @override
  Future<String> fetchData() async {
    // Implement network request logic here
    return 'Data from network';
  }
}

// Implementation of DataService for fetching mock data (useful for testing)
class MockDataService implements DataService {
  @override
  Future<String> fetchData() async {
    return 'Mock data';
  }
}

// Implementation of DataService for fetching data from a local database
class LocalDatabaseService implements DataService {
  @override
  Future<String> fetchData() async {
    // Implement local database access logic here
    return 'Data from local database';
  }
}
