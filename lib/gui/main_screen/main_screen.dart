import 'package:expath_app/gui/main_screen/_widgets/directories_list.dart';
import 'package:expath_app/gui/main_screen/_widgets/directory_buttons_row.dart';
import 'package:expath_app/gui/main_screen/_widgets/rules_buttons_row.dart';
import 'package:expath_app/gui/main_screen/_widgets/rules_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MainScreen of the Application
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EXPATH'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Directory related buttons -----------------------------------
            DirectoryButtonsRow(),
            SizedBox(height: 8),
            // --- Directory list ----------------------------------------------
            Expanded(
              child: DirectoriesList(),
            ),
            SizedBox(height: 8),
            /// --- Rules related buttons --------------------------------------
            RulesButtonsRow(),
            SizedBox(height: 8),
            // --- Rules list --------------------------------------------------
            Expanded(
              child: RuleStacksList(),
            ),
          ],
        ),
      ),
    );
  }
}
