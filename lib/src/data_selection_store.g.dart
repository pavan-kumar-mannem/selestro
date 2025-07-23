// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_selection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DataSelectionStore<T> on _DataSelectionStore<T>, Store {
  Computed<ObservableList<T>>? _$filteredItemsComputed;

  @override
  ObservableList<T> get filteredItems => (_$filteredItemsComputed ??=
          Computed<ObservableList<T>>(() => super.filteredItems,
              name: '_DataSelectionStore.filteredItems'))
      .value;
  Computed<ObservableList<T>>? _$allActiveItemsComputed;

  @override
  ObservableList<T> get allActiveItems => (_$allActiveItemsComputed ??=
          Computed<ObservableList<T>>(() => super.allActiveItems,
              name: '_DataSelectionStore.allActiveItems'))
      .value;

  late final _$searchQueryAtom =
      Atom(name: '_DataSelectionStore.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$isExpandedAtom =
      Atom(name: '_DataSelectionStore.isExpanded', context: context);

  @override
  bool get isExpanded {
    _$isExpandedAtom.reportRead();
    return super.isExpanded;
  }

  @override
  set isExpanded(bool value) {
    _$isExpandedAtom.reportWrite(value, super.isExpanded, () {
      super.isExpanded = value;
    });
  }

  late final _$selectedItemsAtom =
      Atom(name: '_DataSelectionStore.selectedItems', context: context);

  @override
  ObservableList<T> get selectedItems {
    _$selectedItemsAtom.reportRead();
    return super.selectedItems;
  }

  @override
  set selectedItems(ObservableList<T> value) {
    _$selectedItemsAtom.reportWrite(value, super.selectedItems, () {
      super.selectedItems = value;
    });
  }

  late final _$confirmedItemsAtom =
      Atom(name: '_DataSelectionStore.confirmedItems', context: context);

  @override
  ObservableList<T> get confirmedItems {
    _$confirmedItemsAtom.reportRead();
    return super.confirmedItems;
  }

  @override
  set confirmedItems(ObservableList<T> value) {
    _$confirmedItemsAtom.reportWrite(value, super.confirmedItems, () {
      super.confirmedItems = value;
    });
  }

  late final _$_DataSelectionStoreActionController =
      ActionController(name: '_DataSelectionStore', context: context);

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleExpansion() {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.toggleExpansion');
    try {
      return super.toggleExpansion();
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setExpansion(bool value) {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.setExpansion');
    try {
      return super.setExpansion(value);
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleItemSelection(T item) {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.toggleItemSelection');
    try {
      return super.toggleItemSelection(item);
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void confirmSelection() {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.confirmSelection');
    try {
      return super.confirmSelection();
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeConfirmedItem(T item) {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.removeConfirmedItem');
    try {
      return super.removeConfirmedItem(item);
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTemporarySelections() {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.clearTemporarySelections');
    try {
      return super.clearTemporarySelections();
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeContainer() {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.closeContainer');
    try {
      return super.closeContainer();
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void debugPrintState() {
    final _$actionInfo = _$_DataSelectionStoreActionController.startAction(
        name: '_DataSelectionStore.debugPrintState');
    try {
      return super.debugPrintState();
    } finally {
      _$_DataSelectionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchQuery: ${searchQuery},
isExpanded: ${isExpanded},
selectedItems: ${selectedItems},
confirmedItems: ${confirmedItems},
filteredItems: ${filteredItems},
allActiveItems: ${allActiveItems}
    ''';
  }
}
