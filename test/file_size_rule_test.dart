import 'dart:io';

import 'package:expath_app/logic/rules/file_size_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FileSizeRule gibt die Dateigröße in Bytes zurück', () {
    final rule = FileSizeRule();
    final file = File('test_temp.txt');

    try {
      // Testdatei erzeugen
      file.writeAsStringSync('Hello, World!'); // = 13 Bytes

      // Methode anwenden
      final result = rule.apply(file);

      expect(result, isNotNull);
      expect(result, isA<String>());

      final expectedSize = file.lengthSync().toString();
      expect(result, expectedSize);
    } finally {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  });
}
