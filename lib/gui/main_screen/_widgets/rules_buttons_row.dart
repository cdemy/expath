import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:expath_app/gui/rule_editor_screen/rule_editor_screen.dart';
import 'package:expath_app/logic/filesystem/save_load.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for rules-related buttons
class RulesButtonsRow extends ConsumerWidget {
  const RulesButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // "Add rule" button
        ElevatedButton(
          onPressed: () {
            final ruleEditorNotifier = ref.read(refRuleEditor.notifier);
            ruleEditorNotifier.initialize(null); // Initialize the editor with an empty state
            Navigator.push(context, MaterialPageRoute(builder: (context) => RuleStackEditorScreen()));
          },
          child: Text("Regelstapel hinzufügen"),
        ),
        SizedBox(width: 8),
        // "Save rules" button
        ElevatedButton(
          onPressed: () {
            _onSaveRules(context, ref);
          },
          child: Text("Regelstapel-Satz speichern"),
        ),
        SizedBox(width: 8),
        // "Load rules" button
        ElevatedButton(
          onPressed: () {
            _onLoadRules(context, ref);
          },
          child: Text("Regelstapel-Satz laden"),
        ),
      ],
    );
  }

  void _onLoadRules(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(refAppState.notifier);
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final loadedRuleStacks = await SaveLoad.loadRuleStacksFromJson(result.files.single.path!);
      notifier.loadRuleStacks(loadedRuleStacks);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets geladen')));
    }
  }

  void _onSaveRules(BuildContext context, WidgetRef ref) async {
    final state = ref.read(refAppState);
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Regeln speichern',
      fileName: 'rules.json',
    );
    if (path != null) {
      await SaveLoad.saveRuleStacksToJson(state.ruleStacks, path);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets gespeichert')));
    }
  }
}
