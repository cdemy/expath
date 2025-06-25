import 'dart:io';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bundle for editing a single rule with its controllers
class RuleEditingBundle {
  RuleType selectedRuleType;
  Rule rule;
  List<TitledTextEditingController> eingabenControllers;

  RuleEditingBundle({
    required this.selectedRuleType,
    required this.rule,
    required this.eingabenControllers,
  });

  factory RuleEditingBundle.fromRule(Rule rule) {
    final eingabenControllers = <TitledTextEditingController>[];
    for (final eingabe in rule.eingaben) {
      eingabenControllers.add(TitledTextEditingController(
        label: eingabe.label,
        controller: TextEditingController(text: eingabe.value()),
        valueType: eingabe.valueType,
      ));
    }
    return RuleEditingBundle(
      selectedRuleType: rule.ruleType,
      rule: rule,
      eingabenControllers: eingabenControllers,
    );
  }

  factory RuleEditingBundle.empty() {
    final type = RuleType.values.where((v) => !v.onlyFirstPosition).first;
    final rule = type.constructor();
    final eingabenControllers = <TitledTextEditingController>[];
    for (final eingabe in rule.eingaben) {
      eingabenControllers.add(TitledTextEditingController(
        label: eingabe.label,
        controller: TextEditingController(text: eingabe.value()),
        valueType: eingabe.valueType,
      ));
    }
    return RuleEditingBundle(
      selectedRuleType: type,
      rule: rule,
      eingabenControllers: eingabenControllers,
    );
  }

  Rule toRule() {
    for (final ctrl in eingabenControllers) {
      rule.eingaben.firstWhere((e) => e.label == ctrl.label).setValue(ctrl.controller.text.trim());
    }
    return rule;
  }

  void dispose() {
    for (final ctrl in eingabenControllers) {
      ctrl.controller.dispose();
    }
  }
}

/// Controller with metadata for rule input fields
class TitledTextEditingController {
  final String label;
  final TextEditingController controller;
  final Type valueType;

  TitledTextEditingController({
    required this.label,
    required this.controller,
    required this.valueType,
  });
}

/// State class for RuleEditorScreen
class RuleEditorState {
  final RuleStack? existingRuleStack;
  final List<RootDirectoryEntry> directories;
  final TextEditingController excelFieldController;
  final List<RuleEditingBundle> ruleBundles;
  final int? currentFileIndex;
  final int? maxFileIndex;
  final Map<String, String> validationErrors;

  const RuleEditorState({
    this.existingRuleStack,
    required this.directories,
    required this.excelFieldController,
    required this.ruleBundles,
    this.currentFileIndex,
    this.maxFileIndex,
    this.validationErrors = const {},
  });

  RuleEditorState copyWith({
    RuleStack? existingRuleStack,
    List<RootDirectoryEntry>? directories,
    TextEditingController? excelFieldController,
    List<RuleEditingBundle>? ruleBundles,
    int? currentFileIndex,
    int? maxFileIndex,
    Map<String, String>? validationErrors,
  }) {
    return RuleEditorState(
      existingRuleStack: existingRuleStack ?? this.existingRuleStack,
      directories: directories ?? this.directories,
      excelFieldController: excelFieldController ?? this.excelFieldController,
      ruleBundles: ruleBundles ?? this.ruleBundles,
      currentFileIndex: currentFileIndex ?? this.currentFileIndex,
      maxFileIndex: maxFileIndex ?? this.maxFileIndex,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  /// Get the currently selected file for preview
  File? get currentFile {
    if (currentFileIndex == null || directories.isEmpty) return null;
    final files = directories.first.files;
    if (currentFileIndex! >= 0 && currentFileIndex! < files.length) {
      return files[currentFileIndex!];
    }
    return null;
  }

  /// Check if we can navigate to previous file
  bool get canNavigatePrevious => currentFileIndex != null && currentFileIndex! > 0;

  /// Check if we can navigate to next file
  bool get canNavigateNext => 
      currentFileIndex != null && 
      maxFileIndex != null && 
      currentFileIndex! < maxFileIndex!;

  /// Check if the current state is valid for saving
  bool get isValid => validationErrors.isEmpty && excelFieldController.text.trim().isNotEmpty;
}

/// Notifier for RuleEditor state management
class RuleEditorNotifier extends Notifier<RuleEditorState> {
  @override
  RuleEditorState build() {
    return RuleEditorState(
      directories: const [],
      excelFieldController: TextEditingController(),
      ruleBundles: [],
    );
  }

  /// Initialize the rule editor with data
  void initialize(RuleStack? existingRuleStack, List<RootDirectoryEntry> directories) {
    final excelFieldController = TextEditingController();
    final ruleBundles = <RuleEditingBundle>[];

    if (existingRuleStack != null) {
      excelFieldController.text = existingRuleStack.excelField ?? '';
      for (final rule in existingRuleStack.rules) {
        ruleBundles.add(RuleEditingBundle.fromRule(rule));
      }
    } else {
      ruleBundles.add(RuleEditingBundle.empty());
    }

    int? maxFileIndex;
    int? currentFileIndex;
    if (directories.isNotEmpty) {
      final files = directories.first.files;
      maxFileIndex = files.length - 1;
      currentFileIndex = 0;
    }

    state = RuleEditorState(
      existingRuleStack: existingRuleStack,
      directories: directories,
      excelFieldController: excelFieldController,
      ruleBundles: ruleBundles,
      currentFileIndex: currentFileIndex,
      maxFileIndex: maxFileIndex,
    );
  }

  /// Add a new rule bundle
  void addRuleBundle() {
    final updatedBundles = [...state.ruleBundles, RuleEditingBundle.empty()];
    state = state.copyWith(ruleBundles: updatedBundles);
  }

  /// Remove a rule bundle at the specified index
  void removeRuleBundle(int index) {
    if (index >= 0 && index < state.ruleBundles.length) {
      final bundleToRemove = state.ruleBundles[index];
      bundleToRemove.dispose();
      
      final updatedBundles = [...state.ruleBundles];
      updatedBundles.removeAt(index);
      state = state.copyWith(ruleBundles: updatedBundles);
    }
  }

  /// Navigate to previous file
  void navigateToPreviousFile() {
    if (state.canNavigatePrevious) {
      state = state.copyWith(currentFileIndex: state.currentFileIndex! - 1);
    }
  }

  /// Navigate to next file
  void navigateToNextFile() {
    if (state.canNavigateNext) {
      state = state.copyWith(currentFileIndex: state.currentFileIndex! + 1);
    }
  }

  /// Update rule type for a specific bundle
  void updateRuleType(int bundleIndex, RuleType ruleType) {
    if (bundleIndex >= 0 && bundleIndex < state.ruleBundles.length) {
      final bundle = state.ruleBundles[bundleIndex];
      
      // Dispose old controllers
      bundle.dispose();
      
      // Create new bundle with updated rule type
      final newRule = ruleType.constructor();
      final newControllers = <TitledTextEditingController>[];
      for (final eingabe in newRule.eingaben) {
        newControllers.add(TitledTextEditingController(
          label: eingabe.label,
          controller: TextEditingController(text: eingabe.value()),
          valueType: eingabe.valueType,
        ));
      }
      
      final updatedBundle = RuleEditingBundle(
        selectedRuleType: ruleType,
        rule: newRule,
        eingabenControllers: newControllers,
      );
      
      final updatedBundles = [...state.ruleBundles];
      updatedBundles[bundleIndex] = updatedBundle;
      state = state.copyWith(ruleBundles: updatedBundles);
    }
  }

  /// Create RuleStack from current state
  RuleStack createRuleStack() {
    final rules = state.ruleBundles.map((bundle) => bundle.toRule()).toList();
    return RuleStack(
      rules: rules,
      excelField: state.excelFieldController.text.trim(),
    );
  }

  /// Validate current state
  void validate() {
    final errors = <String, String>{};
    
    if (state.excelFieldController.text.trim().isEmpty) {
      errors['excelField'] = 'Excel-Feld darf nicht leer sein';
    }
    
    // Add more validation as needed
    
    state = state.copyWith(validationErrors: errors);
  }

  /// Clean up resources when the notifier is no longer needed
  void cleanup() {
    state.excelFieldController.dispose();
    for (final bundle in state.ruleBundles) {
      bundle.dispose();
    }
  }
}

/// Provider for RuleEditor state
final ruleEditorProvider = NotifierProvider<RuleEditorNotifier, RuleEditorState>(() {
  return RuleEditorNotifier();
});