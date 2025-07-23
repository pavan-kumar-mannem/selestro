import 'package:flutter_test/flutter_test.dart';
import 'package:custom_multi_search/custom_multi_search.dart';

void main() {
  group('DataSelectionStore Tests', () {
    late DataSelectionStore<SearchItem> store;
    late List<SearchItem> testItems;

    setUp(() {
      testItems = [
        const SearchItem(id: '1', name: 'Apple', description: 'Red fruit'),
        const SearchItem(id: '2', name: 'Banana', description: 'Yellow fruit'),
        const SearchItem(
            id: '3', name: 'Cherry', description: 'Small red fruit'),
        const SearchItem(id: '4', name: 'Date', description: 'Sweet fruit'),
        const SearchItem(
            id: '5', name: 'Elderberry', description: 'Purple berry'),
      ];

      store = DataSelectionStore<SearchItem>(
        items: testItems,
        displayProperty: (item) => item.name,
        filterProperty: (item) => item.name,
      );
    });

    test('should initialize with empty search query', () {
      expect(store.searchQuery, equals(''));
    });

    test('should initialize with collapsed state', () {
      expect(store.isExpanded, equals(false));
    });

    test('should initialize with empty selections', () {
      expect(store.selectedItems.isEmpty, equals(true));
      expect(store.confirmedItems.isEmpty, equals(true));
    });

    test('should filter items based on search query', () {
      store.setSearchQuery('app');

      // Wait for debounce
      Future.delayed(const Duration(milliseconds: 350), () {
        expect(store.filteredItems.length, equals(1));
        expect(store.filteredItems.first.name, equals('Apple'));
      });
    });

    test('should toggle expansion state', () {
      expect(store.isExpanded, equals(false));

      store.toggleExpansion();
      expect(store.isExpanded, equals(true));

      store.toggleExpansion();
      expect(store.isExpanded, equals(false));
    });

    test('should set expansion state', () {
      store.setExpansion(true);
      expect(store.isExpanded, equals(true));

      store.setExpansion(false);
      expect(store.isExpanded, equals(false));
    });

    test('should toggle item selection', () {
      final item = testItems.first;

      expect(store.isItemActive(item), equals(false));

      store.toggleItemSelection(item);
      expect(store.isItemActive(item), equals(true));
      expect(store.selectedItems.contains(item), equals(true));

      store.toggleItemSelection(item);
      expect(store.isItemActive(item), equals(false));
      expect(store.selectedItems.contains(item), equals(false));
    });

    test('should confirm selection', () {
      final item1 = testItems[0];
      final item2 = testItems[1];

      // Select items
      store.toggleItemSelection(item1);
      store.toggleItemSelection(item2);

      expect(store.selectedItems.length, equals(2));
      expect(store.confirmedItems.length, equals(0));

      // Confirm selection
      store.confirmSelection();

      expect(store.confirmedItems.length, equals(2));
      expect(store.confirmedItems.contains(item1), equals(true));
      expect(store.confirmedItems.contains(item2), equals(true));
    });

    test('should remove confirmed item', () {
      final item = testItems.first;

      // Select and confirm item
      store.toggleItemSelection(item);
      store.confirmSelection();

      expect(store.confirmedItems.contains(item), equals(true));

      // Remove confirmed item
      store.removeConfirmedItem(item);

      expect(store.confirmedItems.contains(item), equals(false));
      expect(store.selectedItems.contains(item), equals(false));
    });

    test('should close container and reset selections', () {
      final item = testItems.first;

      // Select item and expand
      store.setExpansion(true);
      store.toggleItemSelection(item);

      expect(store.isExpanded, equals(true));
      expect(store.selectedItems.contains(item), equals(true));

      // Close container
      store.closeContainer();

      expect(store.isExpanded, equals(false));
      expect(store.selectedItems.isEmpty, equals(true));
    });

    test('should return correct display name', () {
      final item = testItems.first;
      expect(store.getDisplayName(item), equals('Apple'));
    });

    test('should identify confirmed items', () {
      final item = testItems.first;

      expect(store.isItemConfirmed(item), equals(false));

      store.toggleItemSelection(item);
      store.confirmSelection();

      expect(store.isItemConfirmed(item), equals(true));
    });

    test('should clear temporary selections', () {
      final item1 = testItems[0];
      final item2 = testItems[1];

      // Confirm one item
      store.toggleItemSelection(item1);
      store.confirmSelection();

      // Select another item temporarily
      store.toggleItemSelection(item2);

      expect(store.selectedItems.length, equals(2));

      // Clear temporary selections
      store.clearTemporarySelections();

      expect(store.selectedItems.length, equals(1));
      expect(store.selectedItems.contains(item1), equals(true));
      expect(store.selectedItems.contains(item2), equals(false));
    });

    test('should handle case-insensitive filtering', () {
      store.setSearchQuery('APPLE');

      Future.delayed(const Duration(milliseconds: 350), () {
        expect(store.filteredItems.length, equals(1));
        expect(store.filteredItems.first.name, equals('Apple'));
      });
    });

    test('should return all active items', () {
      final item1 = testItems[0];
      final item2 = testItems[1];

      store.toggleItemSelection(item1);
      store.toggleItemSelection(item2);
      store.confirmSelection();

      final activeItems = store.allActiveItems;
      expect(activeItems.length, equals(2));
      expect(activeItems.contains(item1), equals(true));
      expect(activeItems.contains(item2), equals(true));
    });
  });

  group('SearchItem Tests', () {
    test('should create SearchItem correctly', () {
      const item = SearchItem(
        id: '1',
        name: 'Test Item',
        description: 'Test Description',
      );

      expect(item.id, equals('1'));
      expect(item.name, equals('Test Item'));
      expect(item.description, equals('Test Description'));
    });

    test('should handle equality correctly', () {
      const item1 = SearchItem(id: '1', name: 'Test');
      const item2 = SearchItem(id: '1', name: 'Different Name');
      const item3 = SearchItem(id: '2', name: 'Test');

      expect(item1 == item2, equals(true)); // Same id
      expect(item1 == item3, equals(false)); // Different id
    });

    test('should generate correct hash code', () {
      const item1 = SearchItem(id: '1', name: 'Test');
      const item2 = SearchItem(id: '1', name: 'Different Name');

      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('should generate correct string representation', () {
      const item = SearchItem(id: '1', name: 'Test Item');
      expect(item.toString(), equals('SearchItem(id: 1, name: Test Item)'));
    });
  });
}
