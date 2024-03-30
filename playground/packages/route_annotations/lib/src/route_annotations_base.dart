class RouteConfig {
  const RouteConfig({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

class QueryParam {
  const QueryParam(this.key);

  final String key;
}
