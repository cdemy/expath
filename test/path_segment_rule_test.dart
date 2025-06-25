import 'dart:io';

import 'package:expath_app/logic/rules/path_segment_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PathSegmentRule extrahiert korrektes Segment', () {
    final rule = PathSegmentRule();
    rule.index = 2;
    final path = File('C:\\Daten\\Patent_12345\\Akte.pdf');

    final result = rule.apply(path);

    expect(result, 'Patent_12345');
  });
}
