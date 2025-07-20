import 'dart:developer';

import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state.dart';
import 'package:expath_app/logic/models/proto_eingabe.dart';
import 'package:expath_app/logic/models/proto_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for RuleEditor state
final refRuleEditor = NotifierProvider<RuleEditorNotifier, RuleEditorState>(() {
  return RuleEditorNotifier();
});

/// Notifier for RuleEditor state management
class RuleEditorNotifier extends Notifier<RuleEditorState> {
  @override
  RuleEditorState build() {
    return RuleEditorState(
      excelField: '',
      protoRules: [],
    );
  }

  /// Initialize the rule editor with data
  void initialize(RuleStack? existingRuleStack) {
    final protoRules = <ProtoRule>[];
    var excelField = '';
    if (existingRuleStack != null) {
      excelField = existingRuleStack.excelField;
      for (final rule in existingRuleStack.rules) {
        protoRules.add(ProtoRule.fromRule(rule));
      }
    } else {
      protoRules.add(ProtoRule.empty());
    }

    state = RuleEditorState(
      excelField: excelField,
      protoRules: protoRules,
      // currentFileIndex: currentFileIndex,
      // maxFileIndex: maxFileIndex,
    );
  }

  /// Add a new rule bundle
  void addProtoRule() {
    final updatedProtoRules = [...state.protoRules, ProtoRule.empty()];
    state = state.copyWith(protoRules: updatedProtoRules);
  }

  /// Remove a rule bundle at the specified index
  void removeProtoRule(int index) {
    assert(index >= 0 && index < state.protoRules.length, 'Index out of bounds: $index');
    final updatedProtoRules = [...state.protoRules];
    updatedProtoRules.removeAt(index);
    state = state.copyWith(protoRules: updatedProtoRules);
  }

  // /// Navigate to previous file
  // void navigateToPreviousFile() {
  //   if (state.canNavigatePrevious) {
  //     state = state.copyWith(currentFileIndex: state.currentFileIndex! - 1);
  //   }
  // }

  // /// Navigate to next file
  // void navigateToNextFile() {
  //   if (state.canNavigateNext) {
  //     state = state.copyWith(currentFileIndex: state.currentFileIndex! + 1);
  //   }
  // }

  /// Update rule type for a specific bundle
  void updateProtoRuleRuleType(int index, RuleType ruleType) {
    assert(index >= 0 && index < state.protoRules.length, 'Index out of bounds: $index');
    if (ruleType == state.protoRules[index].ruleType) return;
    // Create new bundle with updated rule type
    final newProtoEingaben = <ProtoEingabe>[];
    for (final eingabeBlueprint in ruleType.eingabeBlueprints) {
      newProtoEingaben.add(ProtoEingabe(
        label: eingabeBlueprint.label,
        valueType: eingabeBlueprint.valueType,
        eingabe: eingabeBlueprint.defaultValue,
      ));
    }
    final updatedProtoRule = ProtoRule(
      ruleType: ruleType,
      protoEingaben: newProtoEingaben,
    );

    final protoRules = [...state.protoRules];
    protoRules[index] = updatedProtoRule;
    state = state.copyWith(protoRules: protoRules);
  }

  // /// Validate current state
  // void validate() {
  //   final errors = <String, String>{};

  //   if (state.excelFieldController.text.trim().isEmpty) {
  //     errors['excelField'] = 'Excel-Feld darf nicht leer sein';
  //   }

  //   // Add more validation as needed

  //   state = state.copyWith(validationErrors: errors);
  // }

  // /// Clean up resources when the notifier is no longer needed
  // void cleanup() {
  //   state.excelFieldController.dispose();
  //   for (final bundle in state.protoRules) {
  //     bundle.dispose();
  //   }
  // }

  void updateExcelField(String value) {
    log('Updating excelField to: $value');
    state = state.copyWith(excelField: value.trim());
  }

  void updateEingabeValue(int ruleIndex, int eingabeIndex, String value) {
    state = state.copyWith(
      protoRules: state.protoRules.map((protoRule) {
        if (protoRule == state.protoRules[ruleIndex]) {
          return protoRule.copyWith(
            protoEingaben: protoRule.protoEingaben.map((eingabe) {
              if (eingabe == protoRule.protoEingaben[eingabeIndex]) {
                return eingabe.copyWith(eingabe: value);
              }
              return eingabe;
            }).toList(),
          );
        }
        return protoRule;
      }).toList(),
    );
  }
}
