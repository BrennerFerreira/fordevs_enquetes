import 'dart:async';

import 'package:fordevs_enquetes/ui/pages/pages.dart';

import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';

class LoginState {
  String? email;
  String? password;
  String? emailError;
  String? passwordError;
  String? authError;
  bool isLoading = false;
  bool get isFormValid =>
      email != null &&
      password != null &&
      emailError == null &&
      passwordError == null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();
  final _state = LoginState();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  @override
  Stream<String?> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  @override
  Stream<String?> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<String?> get authErrorStream =>
      _controller.stream.map((state) => state.authError).distinct();

  @override
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  void _update() {
    if (!_controller.isClosed) {
      _controller.add(_state);
    }
  }

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );

    _update();
  }

  @override
  Future<void> auth() async {
    _state.isLoading = true;
    _update();

    final params = AuthenticationParams(
      email: _state.email!,
      password: _state.password!,
    );
    try {
      await authentication.auth(params);
    } on DomainError catch (error) {
      _state.authError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
