import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  @override
  Future<Map<String, dynamic>> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    Map<String, dynamic> _handleResponse(Response response) {
      if (response.statusCode == 200) {
        return response.body.isEmpty
            ? {'accessToken': null}
            : jsonDecode(response.body);
      } else if (response.statusCode == 204) {
        return {'accessToken': null};
      } else {
        throw HttpError.badRequest;
      }
    }

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    return _handleResponse(response);
  }
}
