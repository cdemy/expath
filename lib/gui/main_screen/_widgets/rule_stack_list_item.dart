import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:expath_app/gui/rule_editor_screen/rule_editor_screen.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Individual rule stack list item widget
class RuleStackListItem extends ConsumerWidget {
  final RuleStack ruleStack;
  final int index;
  final int totalCount;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  const RuleStackListItem({
    super.key,
    required this.ruleStack,
    required this.index,
    required this.totalCount,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(ruleStack.excelField)),
          Expanded(
            flex: 4,
            child: Text(_buildRuleTypesDisplay()),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: index > 0 ? onMoveUp : null,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: index < totalCount - 1 ? onMoveDown : null,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    final ruleEditorNotifier = ref.read(refRuleEditor.notifier);
                    ruleEditorNotifier.initialize(ruleStack); // Initialize the editor with the existing rule stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RuleStackEditorScreen(existingRuleStack: ruleStack),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showRemoveConfirmation(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a more readable display of rule types
  String _buildRuleTypesDisplay() {
    if (ruleStack.rules.isEmpty) {
      return 'Keine Regeln';
    }

    return ruleStack.rules.map((rule) => rule.ruleType.label).join(' → ');
  }

  /// Show confirmation dialog before removing rule stack
  void _showRemoveConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Regelstapel entfernen'),
        content: Text('Möchten Sie den Regelstapel "${ruleStack.excelField}" wirklich entfernen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Entfernen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onRemove();
    }
  }
}
