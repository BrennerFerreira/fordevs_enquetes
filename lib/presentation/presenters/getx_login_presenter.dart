import 'dart:async';

import 'package:get/get.dart';

import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  final _emailError = RxnString();
  final _passwordError = RxnString();
  final _authError = RxnString();
  final _isFormValid = RxBool(false);
  final _isLoading = RxBool(false);
  String? _email;
  String? _password;

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;

  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String?> get authErrorStream => _authError.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(
      field: 'password',
      value: password,
    );

    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _email != null &&
        _password != null &&
        _emailError.value == null &&
        _passwordError.value == null;
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;

    final params = AuthenticationParams(
      email: _email!,
      password: _password!,
    );

    try {
      final account = await authentication.auth(params);
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      _authError.value = error.description;
    } finally {
      _isLoading.value = false;
    }
  }
}
