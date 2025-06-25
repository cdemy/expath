import 'package:expath_app/gui/main_screen/_widgets/rule_stack_list_item.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
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
                  color: Theme.of(context).colorScheme.secondary.withAlpha(25),
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
                      return RuleStackListItem(
                        ruleStack: ruleStack,
                        index: index,
                        totalCount: ruleStacks.length,
                        onMoveUp: () => moveRuleStack(index, index - 1),
                        onMoveDown: () => moveRuleStack(index, index + 1),
                        onEdit: () => editRuleStack(ruleStack),
                        onRemove: () => removeRuleStack(ruleStack),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
