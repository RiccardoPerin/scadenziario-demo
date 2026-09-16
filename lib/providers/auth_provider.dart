import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _pb.authStore.onChange.listen((_) => notifyListeners());
    PocketBaseService.instance.onUnauthorized = _handleUnauthorized;
  }

  static const _tokenKey = 'auth_token';
  static const _recordKey = 'auth_record';
  static const _loginDateKey = 'auth_login_date';

  final PocketBase _pb = PocketBaseService.instance.pb;

  bool get isAuthenticated => _pb.authStore.isValid;

  RecordModel? get currentUser => _pb.authStore.record;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _pb.collection('users').authWithPassword(email, password);
      await _persistSession();
      _isLoading = false;
      notifyListeners();
      return true;
    } on ClientException catch (e) {
      _isLoading = false;
      _errorMessage = e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).authInvalidCredentials;
      notifyListeners();
      return false;
    }
  }

  /// Restores a same-day session saved by [_persistSession], if any.
  /// Must be awaited before the first frame that depends on [isAuthenticated].
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final recordJson = prefs.getString(_recordKey);
    final loginDate = prefs.getString(_loginDateKey);

    if (token != null && recordJson != null && loginDate == _todayString()) {
      final record = RecordModel.fromJson(jsonDecode(recordJson) as Map<String, dynamic>);
      _pb.authStore.save(token, record);
    } else {
      await _clearStoredSession(prefs);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    await _clearStoredSession(await SharedPreferences.getInstance());
    notifyListeners();
  }

  /// Called by [PocketBaseService] whenever any request comes back with a
  /// 401, so an expired/revoked token is treated as a logout everywhere.
  void _handleUnauthorized() {
    if (!_pb.authStore.isValid) return;
    _pb.authStore.clear();
    SharedPreferences.getInstance().then(_clearStoredSession);
  }

  Future<void> _persistSession() async {
    final record = _pb.authStore.record;
    if (record == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _pb.authStore.token);
    await prefs.setString(_recordKey, jsonEncode(record.toJson()));
    await prefs.setString(_loginDateKey, _todayString());
  }

  Future<void> _clearStoredSession(SharedPreferences prefs) async {
    await prefs.remove(_tokenKey);
    await prefs.remove(_recordKey);
    await prefs.remove(_loginDateKey);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}
