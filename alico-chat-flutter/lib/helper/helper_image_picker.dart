import 'package:image_picker/image_picker.dart';

class HelperImagePicker {
  static Future<XFile?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}
