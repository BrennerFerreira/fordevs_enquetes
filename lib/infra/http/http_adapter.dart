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
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty
          ? {'accessToken': null}
          : jsonDecode(response.body);
    } else {
      return {'accessToken': null};
    }
  }
}
