import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/simple_regex_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SimpleRegexRule findet korrekten Treffer im Pfad', () {
    final rule = SimpleRegexRule();
    rule.regex = 'Patent_(\\d+)';
    final path = 'C:/Daten/Patent_12345/Akte.pdf';

    final result = rule.apply(path);

    expect(result, 'Patent_12345');
  });

  test('SimpleRegexRule gibt null zurück, wenn kein Treffer', () {
    final rule = SimpleRegexRule();
    rule.regex = 'Marke_(\\d+)';
    final path = 'C:/Daten/Patent_12345/Akte.pdf';

    final result = rule.apply(path);

    expect(result, isNull);
  });
  test('SimpleRegexRule toJson gibt korrektes Map-Objekt zurück', () {
    final rule = SimpleRegexRule();
    rule.regex = 'Patent_(\\d+)';
    rule.excelField = 'Spalte'; // Standardwert
    final expectedJson = {
      'type': 'simpleRegex',
      'excelField': 'Spalte',
      'regex': 'Patent_(\\d+)',
    };

    expect(rule.toJson(), expectedJson);
  });

  test('SimpleRegexRule fromJson erstellt korrektes Objekt', () {
    final json = {
      'type': 'simpleRegex',
      'excelField': 'Spalte',
      'regex': 'Patent_(\\d+)',
    };

    final rule = SimpleRegexRule.fromJson(json);

    expect(rule.type, 'simpleRegex');
    expect(rule.excelField, 'Spalte');
    expect(rule.regex, 'Patent_(\\d+)');
  });

  test('SimpleRegexRule toJson und fromJson sind zueinander konsistent', () {
    final originalRule = SimpleRegexRule();
    originalRule.regex = 'Patent_(\\d+)';
    originalRule.excelField = 'Spalte'; // Standardwert

    final json = originalRule.toJson();
    final newRule = SimpleRegexRule.fromJson(json);

    expect(newRule.type, originalRule.type);
    expect(newRule.excelField, originalRule.excelField);
    expect(newRule.regex, originalRule.regex);
  });
}
