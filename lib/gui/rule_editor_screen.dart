import 'package:flutter/material.dart';
import '../logic/rule_system.dart'; // <- importiere dein Regel-System

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

    // Werte sammeln
    List<Eingabewert> eingabeWerte = [];
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

    // Regel erzeugen
    Rule rule = RuleFactory.fromEingaben(selectedRuleType!, eingabeWerte);

    // Zurück zum MainScreen mit Regel
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
                  if (value != null) {
                    for (var eingabe in value.eingaben) {
                      _inputControllers[eingabe.label] = TextEditingController();
                    }
                  }
                });
              },
            ),
            SizedBox(height: 16),
            if (selectedRuleType != null)
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
              }).toList(),
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
