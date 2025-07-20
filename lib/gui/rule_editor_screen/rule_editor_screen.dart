import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_excel_input_field.dart';
import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_step_card.dart';
import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleStackEditorScreen extends ConsumerStatefulWidget {
  final RuleStack? existingRuleStack;

  const RuleStackEditorScreen({
    this.existingRuleStack,
    super.key,
  });

  @override
  ConsumerState<RuleStackEditorScreen> createState() => _RuleStackEditorScreenState();
}

class _RuleStackEditorScreenState extends ConsumerState<RuleStackEditorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentFileIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ruleEditorState = ref.watch(refRuleEditor);
    final ruleEditorNotifier = ref.read(refRuleEditor.notifier);
    final appState = ref.watch(refAppState);
    final appStateNotifier = ref.read(refAppState.notifier);
    final directory = appState.directories.isNotEmpty ? appState.directories.first : null;
    final maxIndex = directory != null ? directory.files.length - 1 : null;
    final currentFile = directory != null && directory.files.isNotEmpty ? directory.files[currentFileIndex] : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRuleStack == null ? 'Neuen Regelstapel erstellen' : 'Regelstapel bearbeiten'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (directory != null && directory.files.isNotEmpty)
              Container(
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
                      onPressed: currentFileIndex > 0
                          ? () {
                              setState(() {
                                currentFileIndex--;
                              });
                            }
                          : null,
                    ),
                    Text('${currentFileIndex + 1} / ${maxIndex! + 1}'),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: currentFileIndex < maxIndex
                          ? () {
                              setState(() {
                                currentFileIndex++;
                              });
                            }
                          : null,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currentFile?.path ?? 'Keine Datei',
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            RuleExcelInputField(
              initialValue: widget.existingRuleStack?.excelField,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ruleEditorState.protoRules.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.rule, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Keine Regeln definiert'),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => ruleEditorNotifier.addProtoRule(),
                            icon: Icon(Icons.add),
                            label: Text('Erste Regel hinzufügen'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: ruleEditorState.protoRules.length,
                      itemBuilder: (context, index) {
                        return RuleEditorRuleCard(
                          ruleIndex: index,
                          previewFile: currentFile,
                          key: Key('rule_card:${ruleEditorState.protoRules[index].ruleType}:$index'),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => ruleEditorNotifier.addProtoRule(),
                  icon: Icon(Icons.add),
                  label: Text('Neue Unterregel hinzufügen'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Abbrechen'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final ruleStack = ruleEditorState.toRuleStack();
                        if (ruleStack == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fehler beim Erstellen des Regelstapels')),
                          );
                          return;
                        }
                        if (widget.existingRuleStack != null) {
                          appStateNotifier.updateRuleStack(widget.existingRuleStack!, ruleStack);
                        } else {
                          appStateNotifier.addRuleStack(ruleStack);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('Speichern'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
