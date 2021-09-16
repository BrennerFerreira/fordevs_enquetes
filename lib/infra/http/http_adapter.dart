import 'package:http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    await client.post(Uri.parse(url));
  }
}
