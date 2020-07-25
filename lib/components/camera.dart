import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera {
  var picker = ImagePicker();

  Future<File> takePicture() async {
    var status = await _askPermission();
    if (status == PermissionStatus.granted) {
      var picture = await _imageSelectorCamera();
      if (picture == null) {
        print('user gave up taking picture');
        return null;
      }
      return File(picture.path);
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
    var imageFile = await picker.getImage(source: ImageSource.camera);
    return imageFile;
  }
}
