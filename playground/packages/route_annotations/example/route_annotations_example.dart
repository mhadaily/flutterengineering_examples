import 'package:route_annotations/route_annotations.dart';

void main() {
  var awesome = RouteConfig(name: 'home', path: '/home');
  print('awesome: ${awesome.name}');
}
