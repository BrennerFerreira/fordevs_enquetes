import 'dart:convert';

import 'package:http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  final headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final jsonBody = body != null ? jsonEncode(body) : null;

    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
  }
}
