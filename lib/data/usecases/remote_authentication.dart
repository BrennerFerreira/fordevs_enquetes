import '../../domain/entities/entities.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/authentication.dart';
import '../http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toMap();

    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );

      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      if (error == HttpError.unauthorized) {
        throw DomainError.invalidCredentials;
      }

      throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(
      email: params.email,
      password: params.password,
    );
  }

  Map<String, dynamic> toMap() => {'email': email, 'password': password};
}
