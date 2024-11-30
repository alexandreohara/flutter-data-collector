import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';

class AuthService with ChangeNotifier {
  AuthClient? _client;

  AuthClient? get client => _client;

  Future<void> authenticate() async {
    try {
      final jsonCredentials = jsonDecode(dotenv.env['SERVICE_ACCOUNT_KEY']!);
      final credentials =
          ServiceAccountCredentials.fromJson(json.decode(jsonCredentials));
      final scopes = [
        drive.DriveApi.driveScope,
        sheets.SheetsApi.spreadsheetsScope,
      ];

      _client = await clientViaServiceAccount(credentials, scopes);
      notifyListeners();
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
  }
}
