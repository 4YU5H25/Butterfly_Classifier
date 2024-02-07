import 'package:image_picker/image_picker.dart';

class Media {
  static Future<String?> selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    return file?.path;
  }

  static Future<String?> selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    return file?.path;
  }
}
