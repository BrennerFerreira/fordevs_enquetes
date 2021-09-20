// Mocks generated by Mockito 5.0.15 from annotations
// in fordevs_enquetes/test/data/usecases/authentication/remote_authentication_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordevs_enquetes/data/http/http_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [HttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClient extends _i1.Mock implements _i2.HttpClient {
  MockHttpClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<String, dynamic>> request(
          {String? url, String? method, Map<String, dynamic>? body}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #request, [], {#url: url, #method: method, #body: body}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i3.Future<Map<String, dynamic>>);
  @override
  String toString() => super.toString();
}