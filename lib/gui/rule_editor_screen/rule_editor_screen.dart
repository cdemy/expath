import 'package:flutter/material.dart';
import '../../logic/rules/_rule.dart';
import '../../logic/rules/_rule_type.dart';

class RuleEditorScreen extends StatefulWidget {
  final Rule? existingRule;

  const RuleEditorScreen({super.key, this.existingRule});

  @override
  State<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends State<RuleEditorScreen> {
  RuleType? selectedRuleType;
  Rule? selectedRule;
  final ctrlSpalte = TextEditingController();
  final List<TitledTextEditingController> _eingabenControllers = [];

  @override
  void initState() {
    super.initState();

    if (widget.existingRule != null) {
      selectedRule = widget.existingRule!;
      for (final eingabe in selectedRule!.eingaben) {
        _eingabenControllers.add(TitledTextEditingController(
          label: eingabe.label,
          controller: TextEditingController(text: eingabe.value()),
          valueType: eingabe.valueType,
        ));
      }
    }
  }

  void _saveRule() {
    if (selectedRule == null) return;
    selectedRule!.excelField = ctrlSpalte.text.trim();
    for (final ctrl in _eingabenControllers) {
      final value = ctrl.controller.text.trim();
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte alle Felder ausfüllen')),
        );
        return;
      }
      selectedRule!.eingaben.firstWhere((e) => e.label == ctrl.label).setValue(value);
    }
    Navigator.pop(context, selectedRule);
  }

  @override
  Widget build(BuildContext context) {
    final ruleTypeLabels = RuleType.values.map((e) => e.label).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRule == null ? 'Neue Regel erstellen' : 'Regel bearbeiten'),
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
            // Autocomplete<String>(
            //   initialValue: TextEditingValue(text: selectedRuleType?.label ?? ''),
            //   optionsBuilder: (TextEditingValue textEditingValue) {
            //     if (textEditingValue.text.isEmpty) return ruleTypeLabels;
            //     return ruleTypeLabels
            //         .where((label) => label.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            //   },
            //   onSelected: (String selection) {
            //     final matchedType = RuleType.values.firstWhere((type) => type.label == selection);
            //     setState(() {
            //       selectedRuleType = matchedType;
            //       _eingabenControllers.clear();
            //       selectedRule = matchedType.constructor();
            //       ctrlSpalte.text = selectedRule!.excelField;
            //       for (var eingabe in selectedRule!.eingaben) {
            //         _eingabenControllers.add(TitledTextEditingController(
            //           label: eingabe.label,
            //           controller: TextEditingController(text: eingabe.value()),
            //           valueType: eingabe.valueType,
            //         ));
            //       }
            //     });
            //   },
            //   fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            //     return TextField(
            //       controller: controller,
            //       focusNode: focusNode,
            //       decoration: InputDecoration(
            //         labelText: 'Regeltyp (tippen oder auswählen)',
            //         border: OutlineInputBorder(),
            //       ),
            //     );
            //   },
            // ),
            DropdownButtonFormField<RuleType>(
              decoration: InputDecoration(labelText: 'Regeltyp auswählen'),
              value: selectedRuleType,
              items: RuleType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRuleType = value;
                  // Switching to a new rule type
                  _eingabenControllers.clear();
                  selectedRule = null;
                  ctrlSpalte.clear();
                  if (selectedRuleType != null) {
                    selectedRule = value!.constructor();
                    ctrlSpalte.text = selectedRule!.excelField;
                    for (var eingabe in selectedRule!.eingaben) {
                      _eingabenControllers.add(TitledTextEditingController(
                        label: eingabe.label,
                        controller: TextEditingController(text: eingabe.value()),
                        valueType: eingabe.valueType,
                      ));
                    }
                  }
                });
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: ctrlSpalte,
                decoration: InputDecoration(
                  labelText: 'Spalte',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            ..._eingabenControllers.map((eingabe) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: eingabe.controller,
                  decoration: InputDecoration(
                    labelText: eingabe.label,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: eingabe.valueType == int ? TextInputType.number : TextInputType.text,
                ),
              );
            }),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveRule,
                  child: Text("Speichern"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Abbrechen"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
