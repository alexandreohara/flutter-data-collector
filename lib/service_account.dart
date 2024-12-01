import 'dart:convert';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class AuthService with ChangeNotifier {
  AuthClient? _client;
  DriveApi? _driveApi;
  SheetsApi? _sheetsApi;
  File? _folder;
  File? _sheet;

  AuthClient? get client => _client;
  DriveApi? get driveApi => _driveApi;
  SheetsApi? get sheetsApi => _sheetsApi;
  File? get folder => _folder;
  File? get sheet => _sheet;

  Future<void> authenticate() async {
    try {
      final jsonCredentials = jsonDecode(dotenv.env['SERVICE_ACCOUNT_KEY']!);
      final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
      final scopes = [
        DriveApi.driveScope,
        SheetsApi.spreadsheetsScope,
      ];

      _client = await clientViaServiceAccount(credentials, scopes);
      _driveApi = DriveApi(_client!);
      _sheetsApi = SheetsApi(_client!);
      notifyListeners();
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
  }

  Future<DriveApi> _authenticateDrive() async {
    if (_driveApi == null) {
      await authenticate();
    }
    return _driveApi!;
  }

  Future<SheetsApi> _authenticateSheets() async {
    if (_sheetsApi == null) {
      await authenticate();
    }
    return _sheetsApi!;
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

  Future<File> createFolder(DriveApi driveApi, String folderName) async {
    final folderMetadata = File();
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

      final sheetMetadata = File()
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
      final request = ValueRange(values: [fields]);
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

  Future<void> addRowToSpreadsheet(
      SheetsApi sheetsApi, String spreadsheetId, Item item) async {
    try {
      final row = item.toRow();

      await sheetsApi.spreadsheets.values.append(
        ValueRange(values: [row]),
        spreadsheetId,
        'Sheet1', // Sheet name where the row will be added
        valueInputOption: 'USER_ENTERED',
      );

      print('Row added successfully!');
    } catch (e) {
      print('Error adding row: $e');
      rethrow;
    }
  }
}
