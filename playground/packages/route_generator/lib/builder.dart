import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/route_config_generator.dart';
import 'src/query_param_generator.dart';

// Builder for RouteLibraryConfig
// The generated file will have the extension .router.g.dart
Builder routeLibraryConfigBuilder(BuilderOptions options) =>
    LibraryBuilder(
      RouteConfigGenerator(),
      generatedExtension: '.router.g.dart',
    );

// Builder for RouteConfig
Builder routeConfigBuilder(BuilderOptions options) =>
    SharedPartBuilder(
      [RouteConfigGenerator()],
      'router',
    );

// Builder for QueryParam
Builder queryParamBuilder(BuilderOptions options) =>
    SharedPartBuilder(
      [QueryParamGenerator()],
      'query_param',
    );
