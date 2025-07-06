import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/test_controller.dart';

class TestPage extends GetView<TestController> {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: [
                Text("${controller.percent}"),
                ElevatedButton(
                  onPressed: controller.pickAFile,

                  child: Text('Pick File'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
