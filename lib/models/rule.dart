// import 'package:dj_projektarbeit/models/rule_type_enum.dart';

// abstract class Rule {
//   RuleType get type;
//   String description();
// }

// class RegExRule implements Rule {
//   final String regexPattern;

//   RegExRule(this.regexPattern);

//   @override
//   RuleType get type => RuleType.regEx;

//   @override
//   String description() => 'RegEx: $regexPattern';
// }

// class SubStringRule implements Rule {
//   final int startIndex;
//   final int endIndex;

//   SubStringRule(this.startIndex, this.endIndex);

//   @override
//   RuleType get type => RuleType.subString;

//   @override
//   String description() => 'Substring zwischen /$startIndex und /$endIndex';
// }

// class Eingabewert {
//   final String value;

//   Eingabewert(this.value);
// }
