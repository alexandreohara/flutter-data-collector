import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';

class AuthService with ChangeNotifier {
  AuthClient? _client;
  drive.DriveApi? _driveApi;
  sheets.SheetsApi? _sheetsApi;

  AuthClient? get client => _client;
  drive.DriveApi? get driveApi => _driveApi;
  sheets.SheetsApi? get sheetsApi => _sheetsApi;

  Future<void> authenticate() async {
    try {
      final jsonCredentials = jsonDecode(dotenv.env['SERVICE_ACCOUNT_KEY']!);
      final credentials =
          ServiceAccountCredentials.fromJson(json.decode(jsonCredentials));
      final scopes = [
        drive.DriveApi.driveScope,
        sheets.SheetsApi.spreadsheetsScope,
      ];

      final client = await clientViaServiceAccount(credentials, scopes);
      _driveApi = drive.DriveApi(client);
      _sheetsApi = sheets.SheetsApi(client);
      notifyListeners();
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
  }

  Future<drive.File> createOrFetchFolder(String folderName) async {
    final driveApi = await _authenticateDrive();

    final query =
        "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final fileList = await driveApi.files.list(
        q: query, spaces: 'drive', $fields: 'files(id, name)', pageSize: 1);

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first;
    }
    return createFolder(driveApi, folderName);
  }

  Future<drive.File> createFolder(DriveApi driveApi, String folderName) async {
    final folderMetadata = drive.File();
    folderMetadata.name = folderName;
    folderMetadata.mimeType = 'application/vnd.google-apps.folder';

    final folder = await driveApi.files.create(
      folderMetadata,
      $fields: 'id, name',
    );

    return folder;
  }

  Future<sheets.Spreadsheet> createOrFetchSheets(
      String folderId, String sheetName) async {
    final driveApi = await _authenticateDrive();
    final sheetsApi = await _authenticateSheets();

    // Check if a sheet with the given name exists inside the specified folder
    final query =
        "'$folderId' in parents and name = '$sheetName' and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false";

    final fileList = await driveApi.files.list(
        q: query, spaces: 'drive', $fields: 'files(id, name)', pageSize: 1);

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      final existingFile = fileList.files!.first;
      print(
          'Sheet already exists: ${existingFile.name}, ID: ${existingFile.id}');
      return sheetsApi.spreadsheets.get(existingFile.id!);
    }

    final spreadsheet = sheets.Spreadsheet()
      ..properties = sheets.SpreadsheetProperties(title: sheetName);

    final newSpreadsheet = await sheetsApi.spreadsheets.create(spreadsheet);

    await driveApi.files.update(
      drive.File(parents: [folderId]),
      newSpreadsheet.spreadsheetId!,
      addParents: folderId,
      removeParents: 'root',
      $fields: 'id, parents',
    );

    print(
        'Created new sheet: ${newSpreadsheet.properties?.title}, ID: ${newSpreadsheet.spreadsheetId}');
    return newSpreadsheet;
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
