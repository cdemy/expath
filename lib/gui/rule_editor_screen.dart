import 'package:flutter/material.dart';

class RuleEditorScreen extends StatefulWidget {
  const RuleEditorScreen({super.key});

  @override
  State<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends State<RuleEditorScreen> {
  // Dummy-Values
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _excelFieldController = TextEditingController();
  String? selectedRuleType;

  final List<String> ruleTypes = [
    'Regeltyp 1',
    'Regeltyp 2',
    'Regeltyp 3',
  ];

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
            // Textfelder und Dropdown
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'REGELNAME',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _excelFieldController,
              decoration: InputDecoration(
                labelText: 'EXCEL FELD',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'REGELART',
                border: OutlineInputBorder(),
              ),
              value: selectedRuleType,
              items: ruleTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRuleType = value;
                });
              },
            ),
            SizedBox(height: 32),
            // Work in Progress Platzhalter
            Expanded(
              child: Center(
                child: Text(
                  'WORK IN PROGRESS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
