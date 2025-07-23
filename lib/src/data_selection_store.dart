// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';

import 'package:mobx/mobx.dart';

// Generate the store code with: flutter pub run build_runner build
part 'data_selection_store.g.dart';

// Explicitly specify the generic type in the generated class
class DataSelectionStore<T> = _DataSelectionStore<T>
    with _$DataSelectionStore<T>;

abstract class _DataSelectionStore<T> with Store {
  _DataSelectionStore({
    required this.items,
    required this.displayProperty,
    required this.filterProperty,
  });

  final List<T> items;
  final String Function(T) displayProperty; // Function to get display string
  final String Function(T) filterProperty; // Function to get filter string

  @observable
  String searchQuery = '';

  Timer? _debounce;

  @observable
  bool isExpanded = false;

  @computed
  ObservableList<T> get filteredItems {
    return ObservableList<T>.of(
      items.where(
        (item) => filterProperty(item)
            .toLowerCase()
            .contains(searchQuery.toLowerCase()),
      ),
    );
  }

  @observable
  ObservableList<T> selectedItems = ObservableList<T>.of([]);

  @observable
  ObservableList<T> confirmedItems = ObservableList<T>.of([]);

  // @action
  // void setSearchQuery(String query) {
  //   searchQuery = query;
  // }

  @action
  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      searchQuery = query;
    });
  }

  @action
  void toggleExpansion() {
    isExpanded = !isExpanded;

    // When opening the container, populate selectedItems with confirmed items
    if (isExpanded) {
      selectedItems.clear();
      selectedItems.addAll(confirmedItems);
    }
  }

  @action
  void setExpansion(bool value) {
    isExpanded = value;

    // When opening the container, populate selectedItems with confirmed items
    if (isExpanded) {
      selectedItems.clear();
      selectedItems.addAll(confirmedItems);
    }
  }

  @action
  void toggleItemSelection(T item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    // Force notification of observers
    selectedItems = ObservableList<T>.of(selectedItems);
  }

  @action
  void confirmSelection() {
    // Replace confirmedItems with current selectedItems
    confirmedItems.clear();
    confirmedItems.addAll(selectedItems);

    // Keep selectedItems as is (don't clear) so they remain selected in UI
    // selectedItems will be cleared when container is closed or when setExpansion(false) is called
  }

  @action
  void removeConfirmedItem(T item) {
    confirmedItems.remove(item);
    selectedItems.remove(item); // Also remove from selectedItems if present
  }

  @action
  void clearTemporarySelections() {
    // Call this when closing the container without confirming
    selectedItems.clear();
    selectedItems.addAll(confirmedItems);
  }

  @action
  void closeContainer() {
    isExpanded = false;
    // Reset selectedItems to only show confirmed items
    selectedItems.clear();
  }

  bool isItemActive(T item) {
    return selectedItems.contains(item);
  }

  // Use this method in your UI instead of checking both lists separately
  bool isItemSelected(T item) {
    return selectedItems.contains(item);
  }

  // For debugging - you can remove this later
  @action
  void debugPrintState() {
    //For Debug Purpose
  }

  bool isItemConfirmed(T item) {
    return confirmedItems.contains(item);
  }

  @computed
  ObservableList<T> get allActiveItems =>
      ObservableList<T>.of(confirmedItems.toList());

  String getDisplayName(T item) => displayProperty(item);
}
