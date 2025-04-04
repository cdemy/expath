import 'package:flutter/material.dart';
import '../logic/rule.dart';
import '../logic/rule_type.dart';

class RuleEditorScreen extends StatefulWidget {
  final Rule? existingRule;

  const RuleEditorScreen({super.key, this.existingRule});

  @override
  State<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends State<RuleEditorScreen> {
  RuleType? selectedRuleType;
  final Map<String, TextEditingController> _inputControllers = {};

  @override
  void initState() {
    super.initState();

    if (widget.existingRule != null) {
      final rule = widget.existingRule!;
      selectedRuleType = rule.type;

      switch (rule) {
        case SimpleRegexRule r:
          _inputControllers['Regex'] = TextEditingController(text: r.regex);
          _inputControllers['Excel Spalte'] = TextEditingController(text: r.excelField);
          _inputControllers['Regelname'] = TextEditingController(text: r.name);
          break;

        case PathSegmentRule r:
          _inputControllers['Position'] = TextEditingController(text: r.index.toString());
          _inputControllers['Excel Spalte'] = TextEditingController(text: r.excelField);
          break;

        case ReversePathSegmentRule r:
          _inputControllers['Rückwärts-Index'] = TextEditingController(text: r.reverseIndex.toString());
          _inputControllers['Excel Spalte'] = TextEditingController(text: r.excelField);
          _inputControllers['Regelname'] = TextEditingController(text: r.name);
          break;
      }
    }
  }

  List<Eingabe> getVisibleInputs() {
    if (selectedRuleType == null) return [];

    return selectedRuleType!.eingaben.where((e) {
      return selectedRuleType != RuleType.pathSegment || e.label != 'Regelname';
    }).toList();
  }

  void _saveRule() {
    if (selectedRuleType == null) return;

    final inputs = getVisibleInputs();
    List<Eingabewert> eingabeWerte = [];

    for (var eingabe in inputs) {
      final controller = _inputControllers[eingabe.label];
      if (controller == null || controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bitte alle Felder ausfüllen')),
        );
        return;
      }
      eingabeWerte.add(Eingabewert(controller.text.trim()));
    }

    final rule = RuleFactory.fromEingaben(selectedRuleType!, eingabeWerte);
    Navigator.pop(context, rule);
  }

  @override
  Widget build(BuildContext context) {
    final visibleInputs = getVisibleInputs();

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
                  _inputControllers.clear();
                  for (var eingabe in getVisibleInputs()) {
                    _inputControllers[eingabe.label] = TextEditingController();
                  }
                });
              },
            ),
            SizedBox(height: 16),
            ...visibleInputs.map((eingabe) {
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
