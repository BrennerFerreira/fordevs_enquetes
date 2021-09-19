enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'E-mail e/ou senha incorretos.';
      default:
        return 'Algo inesperado aconteceu. Tente novamente em breve';
    }
  }
}
