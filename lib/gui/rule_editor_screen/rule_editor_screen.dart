import 'package:dj_projektarbeit/logic/filesystem/root_directory_entry.dart';
import 'package:dj_projektarbeit/logic/rules/rule_stack.dart';
import 'package:flutter/material.dart';
import '../../logic/rules/_rule.dart';
import '../../logic/rules/_rule_type.dart';

class RuleStackEditorScreen extends StatefulWidget {
  // final Rule? existingRule;
  final RuleStack? existingRuleStack;
  final List<RootDirectoryEntry> directories;

  const RuleStackEditorScreen(
      {super.key,
      // this.existingRule,
      this.existingRuleStack,
      this.directories = const []});

  @override
  State<RuleStackEditorScreen> createState() => _RuleStackEditorScreenState();
}

class _RuleStackEditorScreenState extends State<RuleStackEditorScreen> {
  RuleType? selectedRuleType;
  RuleStack? selectedRuleStack;
  Rule? selectedRule;
  final ctrlSpalte = TextEditingController();
  final List<_RuleEditingBundle> _ruleBundles = [];
  int? chosenIndex;
  int? maxChosenIndex;

  @override
  void initState() {
    super.initState();
    if (widget.existingRuleStack != null) {
      selectedRuleStack = widget.existingRuleStack!;
      if (selectedRuleStack!.excelField != null) {
        ctrlSpalte.text = selectedRuleStack!.excelField!;
      }
      for (final rule in selectedRuleStack!.rules) {
        _ruleBundles.add(_RuleEditingBundle.fromRule(rule));
      }
    } else {
      _ruleBundles.add(_RuleEditingBundle.empty());
    }
    if (widget.directories.isNotEmpty) {
      final x = widget.directories.first;
      final y = x.files;
      maxChosenIndex = y.length - 1;
      chosenIndex = 0;
    }
  }

  void _saveRule() {
    selectedRuleStack ??= RuleStack(rules: [], excelField: ctrlSpalte.text.trim());
    selectedRuleStack!.excelField = ctrlSpalte.text.trim();
    selectedRuleStack!.rules = _ruleBundles.map((bundle) => bundle.toRule()).toList();
    Navigator.pop(context, selectedRuleStack);
  }

  void _addSubRule() {
    setState(() {
      _ruleBundles.add(_RuleEditingBundle.empty());
    });
  }

  void _removeSubRule(int index) {
    setState(() {
      _ruleBundles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chosenFile = chosenIndex != null ? widget.directories.first.files[chosenIndex!] : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRuleStack == null ? 'Neue Regelgruppe erstellen' : 'Regelgruppe bearbeiten'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chosenIndex != null)
              Row(children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      if (chosenIndex! > 0) {
                        setState(() {
                          chosenIndex = chosenIndex! - 1;
                        });
                      }
                    }),
                Text('$chosenIndex'),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      if (chosenIndex! < maxChosenIndex!) {
                        setState(() {
                          chosenIndex = chosenIndex! + 1;
                        });
                      }
                    }),
              ]),
            TextField(
              controller: ctrlSpalte,
              decoration: InputDecoration(
                labelText: 'Spalte (Excel-Feld für diese Regelgruppe)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _ruleBundles.length,
                itemBuilder: (context, index) {
                  String? resultSoFar;
                  final bundle = _ruleBundles[index];
                  if (chosenFile != null) {
                    final rulesSoFar = _ruleBundles.getRange(0, index + 1).map((rb) => rb.toRule()).toList();
                    final ruleStackSoFar = RuleStack(rules: rulesSoFar);
                    resultSoFar = ruleStackSoFar.apply(chosenFile);
                  }
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Schritt ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 16),
                              Expanded(
                                child: DropdownButton<RuleType>(
                                  value: bundle.selectedRuleType,
                                  items: RuleType.values.where((v) => index == 0 || !v.onlyFirstPosition).map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type.label),
                                    );
                                  }).toList(),
                                  onChanged: (type) {
                                    if (type == null) return;
                                    setState(() {
                                      bundle.selectedRuleType = type;
                                      bundle.rule = type.constructor();
                                      bundle.eingabenControllers.clear();
                                      for (var eingabe in bundle.rule.eingaben) {
                                        bundle.eingabenControllers.add(TitledTextEditingController(
                                          label: eingabe.label,
                                          controller: TextEditingController(text: eingabe.value()),
                                          valueType: eingabe.valueType,
                                        ));
                                      }
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeSubRule(index),
                              ),
                            ],
                          ),
                          ...bundle.eingabenControllers.map((eingabe) {
                            if (bundle.rule.runtimeType.toString() == 'LowerUpperCaseRule' &&
                                eingabe.label == 'Groß-/Kleinschreibung') {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: DropdownButtonFormField<int>(
                                  value: int.tryParse(eingabe.controller.text) ?? 0,
                                  decoration: InputDecoration(
                                    labelText: eingabe.label,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 0, child: Text('Kleinbuchstaben (lowercase)')),
                                    DropdownMenuItem(value: 1, child: Text('Großbuchstaben (UPPERCASE)')),
                                  ],
                                  onChanged: (val) {
                                    eingabe.controller.text = val.toString();
                                    setState(() {});
                                  },
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextField(
                                  controller: eingabe.controller,
                                  decoration: InputDecoration(
                                    labelText: eingabe.label,
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: eingabe.valueType == int ? TextInputType.number : TextInputType.text,
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                ),
                              );
                            }
                          }),
                          if (resultSoFar != null) Text(resultSoFar),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addSubRule,
                  icon: Icon(Icons.add),
                  label: Text('Neue Unterregel hinzufügen'),
                ),
                ElevatedButton(
                  onPressed: _saveRule,
                  child: Text('Speichern'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Abbrechen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleEditingBundle {
  RuleType selectedRuleType;
  Rule rule;
  List<TitledTextEditingController> eingabenControllers;

  _RuleEditingBundle({
    required this.selectedRuleType,
    required this.rule,
    required this.eingabenControllers,
  });

  factory _RuleEditingBundle.fromRule(Rule rule) {
    final eingabenControllers = <TitledTextEditingController>[];
    for (final eingabe in rule.eingaben) {
      eingabenControllers.add(TitledTextEditingController(
        label: eingabe.label,
        controller: TextEditingController(text: eingabe.value()),
        valueType: eingabe.valueType,
      ));
    }
    return _RuleEditingBundle(
      selectedRuleType: rule.ruleType,
      rule: rule,
      eingabenControllers: eingabenControllers,
    );
  }

  factory _RuleEditingBundle.empty() {
    final type = RuleType.values.where((v) => !v.onlyFirstPosition).first;
    final rule = type.constructor();
    final eingabenControllers = <TitledTextEditingController>[];
    for (final eingabe in rule.eingaben) {
      eingabenControllers.add(TitledTextEditingController(
        label: eingabe.label,
        controller: TextEditingController(text: eingabe.value()),
        valueType: eingabe.valueType,
      ));
    }
    return _RuleEditingBundle(
      selectedRuleType: type,
      rule: rule,
      eingabenControllers: eingabenControllers,
    );
  }

  Rule toRule() {
    for (final ctrl in eingabenControllers) {
      rule.eingaben.firstWhere((e) => e.label == ctrl.label).setValue(ctrl.controller.text.trim());
    }
    return rule;
  }
}

class TitledTextEditingController {
  final String label;
  final TextEditingController controller;
  final Type valueType;

  TitledTextEditingController({
    required this.label,
    required this.controller,
    required this.valueType,
  });
}
