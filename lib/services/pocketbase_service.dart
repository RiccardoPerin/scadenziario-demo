import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

/// Single source of truth for the PocketBase base URL.
/// Change this when switching from local dev to the company server.
const String pocketBaseUrl = 'https://scadenziario-demo-production.up.railway.app';

class PocketBaseService {
  PocketBaseService._internal() {
    pb = PocketBase(
      pocketBaseUrl,
      httpClientFactory: () =>
          _UnauthorizedInterceptorClient(http.Client(), () => onUnauthorized?.call()),
    );
  }

  static final PocketBaseService instance = PocketBaseService._internal();

  late final PocketBase pb;

  /// Invoked whenever any request made through [pb] receives a 401 response,
  /// regardless of which provider/collection triggered it. Used to treat the
  /// current session as expired app-wide.
  void Function()? onUnauthorized;
}

class _UnauthorizedInterceptorClient extends http.BaseClient {
  _UnauthorizedInterceptorClient(this._inner, this._onUnauthorized);

  final http.Client _inner;
  final void Function() _onUnauthorized;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);
    if (response.statusCode == 401) {
      _onUnauthorized();
    }
    return response;
  }

  @override
  void close() => _inner.close();
}
