import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for rules-related buttons
class RulesButtonsRow extends ConsumerWidget {
  final VoidCallback onAddRule;
  final VoidCallback onSaveRules;
  final VoidCallback onLoadRules;

  const RulesButtonsRow({
    super.key,
    required this.onAddRule,
    required this.onSaveRules,
    required this.onLoadRules,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // "Add rule" button
        ElevatedButton(
          onPressed: onAddRule,
          child: Text("Regel hinzufügen"),
        ),
        SizedBox(width: 8),
        // "Save rules" button
        ElevatedButton(
          onPressed: onSaveRules,
          child: Text("Regelsatz speichern"),
        ),
        SizedBox(width: 8),
        // "Load rules" button
        ElevatedButton(
          onPressed: onLoadRules,
          child: Text("Regelsatz laden"),
        ),
      ],
    );
  }
}