import 'package:expath_app/gui/preview_screen/state/preview_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for PreviewScreen state
final refPreviewScreen = NotifierProvider.autoDispose<PreviewScreenNotifier, PreviewScreenState>(() {
  return PreviewScreenNotifier();
});

/// Notifier for PreviewScreen state management
class PreviewScreenNotifier extends AutoDisposeNotifier<PreviewScreenState> {
  @override
  PreviewScreenState build() => PreviewScreenState(selectedRows: {});

  /// Toggle selection of a file
  void toggleSelection(int index) {
    final updatedSelectedRows = Set<int>.from(state.selectedRows);
    if (updatedSelectedRows.contains(index)) {
      updatedSelectedRows.remove(index);
    } else {
      updatedSelectedRows.add(index);
    }
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }

  /// Select all files
  void selectAll(int length) {
    final updatedSelectedRows = List.generate(length, (index) => index).toSet();
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }

  /// Deselect all files
  void deselectAll() {
    final updatedSelectedRows = <int>{};
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }

  void setLoading(bool bool) {
    state = state.copyWith(isLoading: bool);
  }
}
