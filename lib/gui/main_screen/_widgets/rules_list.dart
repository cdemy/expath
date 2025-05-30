import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:flutter/material.dart';

class RuleStacksList extends StatelessWidget {
  final List<RuleStack> ruleStacks;
  final Function(int, int) moveRuleStack;
  final Function(RuleStack) editRuleStack;
  final Function(RuleStack) removeRuleStack;

  const RuleStacksList({
    required this.ruleStacks,
    required this.moveRuleStack,
    required this.editRuleStack,
    required this.removeRuleStack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: ruleStacks.isEmpty
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
                    itemCount: ruleStacks.length,
                    itemBuilder: (context, index) {
                      final ruleStack = ruleStacks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(ruleStack.excelField ?? '???')),
                            Expanded(
                                flex: 4,
                                child:
                                    Text(ruleStack.rules.fold('', (prev, next) => prev + '->${next.ruleType.label}'))),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    onPressed: index > 0 ? () => moveRuleStack(index, index - 1) : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_downward),
                                    onPressed:
                                        index < ruleStacks.length - 1 ? () => moveRuleStack(index, index + 1) : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => editRuleStack(ruleStack),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => removeRuleStack(ruleStack),
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
