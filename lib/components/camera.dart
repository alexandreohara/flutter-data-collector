import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

const ANDROID_DIRECTORY_PATH =
    '/storage/emulated/0/Android/data/com.example.data_collector/files/Pictures';

class Camera {
  var picker = ImagePicker();

  Future<File> takePicture([String pictureName]) async {
    var status = await _askPermission();
    if (status == PermissionStatus.granted) {
      var picture = await _imageSelectorCamera();
      if (picture == null && Platform.isAndroid) {
        _deleteIncorretFile();
        print('user gave up taking picture');
        return null;
      }
      if (pictureName?.isNotEmpty ?? false) {
        String dir = path.dirname(picture.path);
        String newPath = path.join(dir, pictureName);
        File renamedFile = await File(picture.path).copy(newPath);
        File(picture.path).delete();
        return renamedFile;
      }
    }

    print('permission not granted');
    return null;
  }

  Future<PermissionStatus> _askPermission() async {
    var restult =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    return restult[PermissionGroup.camera];
  }

  Future<PickedFile> _imageSelectorCamera() async {
    return picker.getImage(source: ImageSource.camera);
  }

  Future<void> _deleteIncorretFile() async {
    final directory = new Directory(ANDROID_DIRECTORY_PATH);

    var allFiles = directory.list();

    var incorrectFiles = await allFiles.where((file) {
      return !file.path
              .substring(ANDROID_DIRECTORY_PATH.length + 1)
              .startsWith('20') &&
          file.path.contains(new RegExp(r'\.(png|jpe?g)'));
    }).toList();

    var lastFile = incorrectFiles.last;

    File(lastFile.path).delete();
  }
}
