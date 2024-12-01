import 'dart:convert';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class AuthService with ChangeNotifier {
  AuthClient? _client;
  drive.DriveApi? _driveApi;
  sheets.SheetsApi? _sheetsApi;
  drive.File? _folder;
  drive.File? _sheet;

  AuthClient? get client => _client;
  drive.DriveApi? get driveApi => _driveApi;
  sheets.SheetsApi? get sheetsApi => _sheetsApi;
  drive.File? get folder => _folder;
  drive.File? get sheet => _sheet;

  Future<void> authenticate() async {
    try {
      final jsonCredentials = jsonDecode(dotenv.env['SERVICE_ACCOUNT_KEY']!);
      final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
      final scopes = [
        drive.DriveApi.driveScope,
        sheets.SheetsApi.spreadsheetsScope,
      ];

      _client = await clientViaServiceAccount(credentials, scopes);
      _driveApi = drive.DriveApi(_client!);
      _sheetsApi = sheets.SheetsApi(_client!);
      notifyListeners();
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
  }

  Future<String> createOrFetchFolder(String folderName) async {
    final driveApi = await _authenticateDrive();

    final query =
        "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final fileList = await driveApi.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name, parents, trashed)',
        pageSize: 1);
    print(fileList.files!.first.parents);

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id ?? '';
    }
    _folder = await createFolder(driveApi, folderName);
    notifyListeners();
    return _folder!.id ?? '';
  }

  Future<drive.File> createFolder(DriveApi driveApi, String folderName) async {
    final folderMetadata = drive.File();
    folderMetadata.name = folderName;
    folderMetadata.mimeType = 'application/vnd.google-apps.folder';
    folderMetadata.parents = [dotenv.env['PARENT_ID']!];

    final folder = await driveApi.files.create(
      folderMetadata,
      $fields: 'id, name',
    );

    return folder;
  }

  Future<String> createOrFetchSheets(String folderId, String sheetName) async {
    try {
      final driveApi = await _authenticateDrive();
      final sheetsApi = await _authenticateSheets();

      final query =
          "'$folderId' in parents and name = '$sheetName' and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false";

      final fileList = await driveApi.files.list(
          q: query, spaces: 'drive', $fields: 'files(id, name)', pageSize: 1);

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final existingFile = fileList.files!.first;
        print(
            'Sheet already exists: ${existingFile.name}, ID: ${existingFile.id}');
        return existingFile.id!;
      }

      final sheetMetadata = drive.File()
        ..name = sheetName
        ..mimeType = 'application/vnd.google-apps.spreadsheet'
        ..parents = [folderId];

      _sheet = await driveApi.files
          .create(sheetMetadata, $fields: 'id, name, mimeType, parents');
      await addFields(sheetsApi, _sheet!.id!);
      notifyListeners();

      return _sheet!.id ?? '';
    } catch (e) {
      print('Error creating or fetching sheet: $e');
      rethrow;
    }
  }

  Future<void> addFields(SheetsApi sheetsApi, String spreadsheetId) async {
    try {
      final fields = Item.getFields();
      final request = sheets.ValueRange(values: [fields]);
      await sheetsApi.spreadsheets.values.update(
        request,
        spreadsheetId,
        'A1',
        valueInputOption: 'USER_ENTERED',
      );
    } catch (e) {
      print('Error adding fields to spreadsheet: $e');
      rethrow;
    }
  }

  Future<drive.DriveApi> _authenticateDrive() async {
    if (_driveApi == null) {
      await authenticate();
    }
    return _driveApi!;
  }

  Future<sheets.SheetsApi> _authenticateSheets() async {
    if (_sheetsApi == null) {
      await authenticate();
    }
    return _sheetsApi!;
  }
}
