import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_step_card.dart';
import 'package:expath_app/gui/rule_editor_screen/rule_editor_state.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleStackEditorScreen extends ConsumerWidget {
  final RuleStack? existingRuleStack;
  final List<RootDirectoryEntry> directories;

  const RuleStackEditorScreen({
    super.key,
    this.existingRuleStack,
    this.directories = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(ruleEditorProvider);
    final editorNotifier = ref.read(ruleEditorProvider.notifier);

    // Initialize if not already done
    if (editorState.directories.isEmpty && editorState.ruleBundles.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        editorNotifier.initialize(existingRuleStack, directories);
      });
    }

    return Scaffold(
      appBar: _buildAppBar(context, editorNotifier),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileNavigator(editorState, editorNotifier),
            SizedBox(height: 16),
            _buildExcelFieldInput(editorState),
            SizedBox(height: 16),
            Expanded(
              child: _buildRulesList(editorState, editorNotifier),
            ),
            SizedBox(height: 16),
            _buildActionButtons(context, editorState, editorNotifier),
          ],
        ),
      ),
    );
  }

  /// Build the app bar
  AppBar _buildAppBar(BuildContext context, RuleEditorNotifier notifier) {
    return AppBar(
      title: Text(existingRuleStack == null ? 'Neue Regelgruppe erstellen' : 'Regelgruppe bearbeiten'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          notifier.cleanup();
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Build file navigator for preview
  Widget _buildFileNavigator(RuleEditorState state, RuleEditorNotifier notifier) {
    if (state.currentFileIndex == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.preview, size: 16),
          SizedBox(width: 8),
          Text('Vorschau-Datei:'),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: state.canNavigatePrevious ? () => notifier.navigateToPreviousFile() : null,
          ),
          Text('${state.currentFileIndex! + 1} / ${(state.maxFileIndex ?? 0) + 1}'),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: state.canNavigateNext ? () => notifier.navigateToNextFile() : null,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              state.currentFile?.path ?? 'Keine Datei',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Excel field input
  Widget _buildExcelFieldInput(RuleEditorState state) {
    return TextField(
      controller: state.excelFieldController,
      decoration: InputDecoration(
        labelText: 'Spalte (Excel-Feld für diese Regelgruppe)',
        border: OutlineInputBorder(),
        errorText: state.validationErrors['excelField'],
        helperText: 'Name der Spalte in der Excel-Datei',
      ),
    );
  }

  /// Build the list of rule steps
  Widget _buildRulesList(RuleEditorState state, RuleEditorNotifier notifier) {
    if (state.ruleBundles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Keine Regeln definiert'),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => notifier.addRuleBundle(),
              icon: Icon(Icons.add),
              label: Text('Erste Regel hinzufügen'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.ruleBundles.length,
      itemBuilder: (context, index) {
        final bundle = state.ruleBundles[index];
        return RuleStepCard(
          stepIndex: index,
          bundle: bundle,
          previewFile: state.currentFile,
          allBundles: state.ruleBundles,
          onRuleTypeChanged: (ruleType) => notifier.updateRuleType(index, ruleType),
          onRemove: () => notifier.removeRuleBundle(index),
          onInputChanged: () => notifier.validate(),
        );
      },
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, RuleEditorState state, RuleEditorNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () => notifier.addRuleBundle(),
          icon: Icon(Icons.add),
          label: Text('Neue Unterregel hinzufügen'),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                notifier.cleanup();
                Navigator.pop(context);
              },
              child: Text('Abbrechen'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: state.isValid ? () => _saveRule(context, notifier) : null,
              child: Text('Speichern'),
            ),
          ],
        ),
      ],
    );
  }

  /// Save the rule and return to previous screen
  void _saveRule(BuildContext context, RuleEditorNotifier notifier) {
    notifier.validate();
    // Get the current state from the provider instead of accessing state directly
    final currentState = notifier.build();
    
    if (currentState.isValid) {
      final ruleStack = notifier.createRuleStack();
      notifier.cleanup();
      Navigator.pop(context, ruleStack);
    }
  }
}
