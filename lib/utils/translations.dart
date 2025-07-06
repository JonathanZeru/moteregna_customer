import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello World', //TODO
    },
    'am_ET': {'hello': 'Hello World'},
    'or_ET': {'hello': 'Hello World'},
  };
}
