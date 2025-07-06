import 'dart:io';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gibe_market/utils/utils.dart';

class TestController extends GetxController {
  double percent = 0;
  Future<void> pickAFile() async {
    final file = await FileHandler.pickFile(
      allowedExtensions: ['png', 'mp4', 'exe'],
    );

    if (file == null) {
      return;
    }

    final instance = NetworkHandler(
      baseUrl:
          'https://yl7uiwumla.execute-api.eu-north-1.amazonaws.com/dev/utils/upload-tester/',
      contentType: RContentTypes.formData,
    );
    logger.i(file);
    final body = {'file': File(file.files[0].path ?? "")};

    final response = await instance.post(
      body: body,
      onProgress: (byte, total) {
        percent = (byte / total) * 100;

        update();
      },
    );

    logger.i(response.body);
  }
}
