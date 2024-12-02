import 'dart:io';
import 'dart:convert';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:mime/mime.dart';

class AuthService with ChangeNotifier {
  AuthClient? _client;
  drive.DriveApi? _driveApi;
  SheetsApi? _sheetsApi;
  drive.File? _folder;
  drive.File? _sheet;

  AuthClient? get client => _client;
  drive.DriveApi? get driveApi => _driveApi;
  SheetsApi? get sheetsApi => _sheetsApi;
  drive.File? get folder => _folder;
  drive.File? get sheet => _sheet;

  Future<void> authenticate() async {
    try {
      final jsonCredentials = jsonDecode(dotenv.env['SERVICE_ACCOUNT_KEY']!);
      final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);
      final scopes = [
        drive.DriveApi.driveScope,
        SheetsApi.spreadsheetsScope,
      ];

      _client = await clientViaServiceAccount(credentials, scopes);
      _driveApi = drive.DriveApi(_client!);
      _sheetsApi = SheetsApi(_client!);
      notifyListeners();
    } catch (e) {
      print('Authentication failed: $e');
      rethrow;
    }
  }

  Future<drive.DriveApi> _authenticateDrive() async {
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

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      _folder = fileList.files!.first;
      notifyListeners();
      return fileList.files!.first.id ?? '';
    }
    _folder = await createFolder(driveApi, folderName);
    notifyListeners();
    return _folder!.id ?? '';
  }

  Future<drive.File> createFolder(
      drive.DriveApi driveApi, String folderName) async {
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

  Future<String> fetchSheets(String folderId, String sheetName) async {
    try {
      final driveApi = await _authenticateDrive();

      final query =
          "'$folderId' in parents and name = '$sheetName' and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false";

      final fileList = await driveApi.files.list(
          q: query, spaces: 'drive', $fields: 'files(id, name)', pageSize: 1);

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        _sheet = fileList.files!.first;
        notifyListeners();
        print('Sheet already exists: ${_sheet!.name}, ID: ${_sheet!.id}');
        return _sheet!.id!;
      }
      throw ArgumentError('Sheet not found');
    } catch (e) {
      FetchSheetException('$e');
      rethrow;
    }
  }

  Future<String> createOrFetchSheets(String folderId, String sheetName) async {
    try {
      await fetchSheets(folderId, sheetName);
      final driveApi = await _authenticateDrive();
      final sheetsApi = await _authenticateSheets();

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
      throw CreateOrFetchSheetException('$e');
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
      throw ErrorAddingRowException('$e');
    }
  }

  Future<void> addRowToSpreadsheet(String spreadsheetId, Item item) async {
    try {
      final row = item.toRow();
      final sheetsApi = await _authenticateSheets();
      final response = await _sheetsApi!.spreadsheets.values.get(
        spreadsheetId,
        'A:A',
      );
      final existingNumber =
          response.values?.map((row) => row.isNotEmpty ? row[0] : '').toSet() ??
              {};
      if (existingNumber.contains(item.number)) {
        throw NumberAlreadyExistsException(item.number!);
      }
      await sheetsApi.spreadsheets.values.append(
        ValueRange(values: [row]),
        spreadsheetId,
        'Sheet1',
        valueInputOption: 'USER_ENTERED',
      );

      print('Row added successfully!');
    } catch (e) {
      throw ErrorAddingRowException('$e');
    }
  }

  Future<String> uploadFile(String folderId, File file) async {
    try {
      final driveApi = await _authenticateDrive();
      final query =
          "'$folderId' in parents and name = '${file.uri.pathSegments.last}' and trashed = false";
      final fileList = await driveApi.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name)',
        pageSize: 1,
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        print(
            'File ${file.uri.pathSegments.last} already exists. Skipping upload.');
        throw Exception('A imagem ${file.uri.pathSegments.last} já existe');
      }

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      final media = drive.Media(file.openRead(), file.lengthSync());
      final driveFile = drive.File()
        ..name = file.uri.pathSegments.last
        ..mimeType = mimeType
        ..parents = [folderId];

      final result = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );

      print('File uploaded: ${result.id}');
      return result.id ?? 'No ID';
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
