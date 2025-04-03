import 'package:dj_projektarbeit/logic/rule_type.dart';
import 'package:flutter/material.dart';
import '../logic/rule.dart';

class RuleEditorScreen extends StatefulWidget {
  const RuleEditorScreen({super.key});

  @override
  State<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends State<RuleEditorScreen> {
  RuleType? selectedRuleType;
  final Map<String, TextEditingController> _inputControllers = {};

  void _saveRule() {
    if (selectedRuleType == null) return;

    List<Eingabewert> eingabeWerte = [];

    // Check if input is required and not empty
    if (selectedRuleType!.eingaben.isNotEmpty) {
      for (var eingabe in selectedRuleType!.eingaben) {
        final controller = _inputControllers[eingabe.label];
        if (controller == null || controller.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bitte alle Felder ausfüllen')),
          );
          return;
        }
        eingabeWerte.add(Eingabewert(controller.text));
      }
    }

    // Create Rule
    final rule = RuleFactory.fromEingaben(selectedRuleType!, eingabeWerte);

    // Debug um zu sehen ob Regel ankommt
    print("Regel erzeugt: ${rule.name}");

    // Return Rule to previous screen
    Navigator.pop(context, rule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Regel Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<RuleType>(
              decoration: InputDecoration(labelText: 'Regeltyp auswählen'),
              value: selectedRuleType,
              items: RuleType.values.map((ruleType) {
                return DropdownMenuItem(
                  value: ruleType,
                  child: Text(ruleType.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRuleType = value;
                  _inputControllers.clear();
                  if (value != null && value.eingaben.isNotEmpty) {
                    for (var eingabe in value.eingaben) {
                      _inputControllers[eingabe.label] = TextEditingController();
                    }
                  }
                });
              },
            ),
            SizedBox(height: 16),

            // Dynamic input fields for regEx
            if (selectedRuleType?.eingaben.isNotEmpty ?? false)
              ...selectedRuleType!.eingaben.map((eingabe) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _inputControllers[eingabe.label],
                    decoration: InputDecoration(
                      labelText: eingabe.label,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: eingabe.valueType == 'int' ? TextInputType.number : TextInputType.text,
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
