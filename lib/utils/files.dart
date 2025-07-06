import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:path_provider/path_provider.dart";

class FileHandler {
  FileHandler();
  static Future<File> getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();

    return File("${dir.path}/$fileName");
  }

  static Future<FilePickerResult?> pickFile({
    required List<String> allowedExtensions,
  }) async {
    return FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
  }

  static void test() async {
    final res = await FileHandler.pickFile(allowedExtensions: ["csv"]);

    if (res != null) {}
  }

  static Future<XFile?> pickImage() async {
    final picker = ImagePicker();

    final img = await picker.pickImage(source: ImageSource.camera);

    return img;
  }

  static Future<File?> imagePickAndCrop({
    ImageSource source = ImageSource.gallery,
  }) async {
    final img = await ImagePicker().pickImage(source: source);
    if (img == null) return null;
    final cropped = await ImageCropper().cropImage(sourcePath: img.path);

    if (cropped == null) return null;
    return File(cropped.path);
  }
}
