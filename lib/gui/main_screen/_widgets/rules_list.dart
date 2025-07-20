import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/main_screen/_widgets/rule_stack_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleStacksList extends ConsumerWidget {
  const RuleStacksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(refAppState);
    final appStateNotifier = ref.watch(refAppState.notifier);
    final ruleStacks = appState.ruleStacks;
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
                        onMoveUp: () => appStateNotifier.moveRuleStack(index, index - 1),
                        onMoveDown: () => appStateNotifier.moveRuleStack(index, index + 1),
                        onRemove: () => appStateNotifier.removeRuleStack(ruleStack),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
