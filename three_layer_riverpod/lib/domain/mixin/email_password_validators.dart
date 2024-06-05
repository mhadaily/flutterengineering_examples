import 'package:three_layer_riverpod/domain/domain.dart';

mixin EmailPasswordValidators {
  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  String? validatePassword(String? value) {
    return Validators.validatePassword(value);
  }
}
