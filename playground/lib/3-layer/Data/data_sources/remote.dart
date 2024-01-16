class RemoteService {
  Future<String> getRemoteData() async {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        return '''[
          'Remote 1',
          'Remote 2',
          'Remote 3',
        ]''';
      },
    );
  }
}
