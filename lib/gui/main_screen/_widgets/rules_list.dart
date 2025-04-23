import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:flutter/material.dart';

class RulesList extends StatelessWidget {
  final List<Rule> rules;
  final Function(int, int) moveRule;
  final Function(Rule) editRule;
  final Function(Rule) removeRule;

  const RulesList({
    required this.rules,
    required this.moveRule,
    required this.editRule,
    required this.removeRule,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: rules.isEmpty
          ? Center(child: Text("Noch keine Regeln hinzugefügt."))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text('Excel-Spalte', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 4, child: Text('Regelname', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Aktionen', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      final rule = rules[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(rule.excelField)),
                            Expanded(flex: 4, child: Text(rule.ruleType.label)),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    onPressed: index > 0 ? () => moveRule(index, index - 1) : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_downward),
                                    onPressed: index < rules.length - 1 ? () => moveRule(index, index + 1) : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => editRule(rule),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => removeRule(rule),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
