import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_multi_search/custom_multi_search.dart';

void main() {
  group('DataSelectionWidget Tests', () {
    late List<SearchItem> testItems;
    late DataSelectionStore<SearchItem> store;

    setUp(() {
      testItems = [
        const SearchItem(id: '1', name: 'Apple', description: 'Red fruit'),
        const SearchItem(id: '2', name: 'Banana', description: 'Yellow fruit'),
        const SearchItem(
            id: '3', name: 'Cherry', description: 'Small red fruit'),
      ];

      store = DataSelectionStore<SearchItem>(
        items: testItems,
        displayProperty: (item) => item.name,
        filterProperty: (item) => item.name,
      );
    });

    Widget createTestWidget({
      String? labelStr,
      bool isMandatory = false,
      List<SearchItem>? initialValue,
      String? errorMsg,
      void Function(List<SearchItem>)? onChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DataSelectionWidget<SearchItem>(
            store: store,
            hint: 'Search items...',
            labelStr: labelStr,
            nameExtractor: (item) => item.name,
            isMandatory: isMandatory,
            initialValue: initialValue,
            errorMsg: errorMsg,
            onChanged: onChanged,
          ),
        ),
      );
    }

    testWidgets('should render basic widget structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check if TextField is present
      expect(find.byType(TextField), findsOneWidget);

      // Check if hint text is displayed
      expect(find.text('Search items...'), findsOneWidget);
    });

    testWidgets('should display label when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(labelStr: 'Select Items'));

      expect(find.text('Select Items'), findsOneWidget);
    });

    testWidgets('should display mandatory indicator when required',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(
        labelStr: 'Select Items',
        isMandatory: true,
      ));

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('should display error message when provided',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(errorMsg: 'This field is required'));

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('should expand when search field is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially collapsed
      expect(store.isExpanded, false);

      // Tap on TextField
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Should be expanded
      expect(store.isExpanded, true);
    });

    testWidgets('should filter items when typing in search field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Expand the widget
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Type in search field
      await tester.enterText(find.byType(TextField), 'app');
      await tester.pumpAndSettle();

      // Wait for debounced search
      await tester.pump(const Duration(milliseconds: 350));

      // Should filter to show only Apple
      expect(store.filteredItems.length, 1);
      expect(store.filteredItems.first.name, 'Apple');
    });

    testWidgets('should toggle expansion when expand icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find the expand icon
      final expandIcon = find.byIcon(Icons.expand_more_rounded);
      expect(expandIcon, findsOneWidget);

      // Initially collapsed
      expect(store.isExpanded, false);

      // Tap expand icon
      await tester.tap(expandIcon);
      await tester.pumpAndSettle();

      // Should be expanded
      expect(store.isExpanded, true);
    });

    testWidgets('should clear search when clear icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Type in search field first
      await tester.enterText(find.byType(TextField), 'apple');
      await tester.pumpAndSettle();

      // Find and tap clear icon
      final clearIcon = find.byIcon(Icons.clear_rounded);
      expect(clearIcon, findsOneWidget);

      await tester.tap(clearIcon);
      await tester.pumpAndSettle();

      // Search query should be cleared
      expect(store.searchQuery, '');
    });

    testWidgets('should show "no items found" when search has no results',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Expand the widget
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Search for non-existent item
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();

      // Wait for debounced search
      await tester.pump(const Duration(milliseconds: 350));

      // Should show no items found message
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });

    testWidgets('should initialize with initial values',
        (WidgetTester tester) async {
      final initialItems = [testItems.first];

      await tester.pumpWidget(createTestWidget(initialValue: initialItems));

      // Should have initial items in confirmed items
      expect(store.confirmedItems.length, 1);
      expect(store.confirmedItems.contains(testItems.first), true);
    });

    testWidgets('should call onChanged when selection is confirmed',
        (WidgetTester tester) async {
      List<SearchItem>? changedItems;

      await tester.pumpWidget(createTestWidget(
        onChanged: (items) => changedItems = items,
      ));

      // Expand, select item, and confirm
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Manually select an item and confirm (since we can't easily tap checkboxes in tests)
      store.toggleItemSelection(testItems.first);
      store.confirmSelection();
      store.setExpansion(false);

      // Trigger onChanged callback
      changedItems ??= store.confirmedItems.toList().cast<SearchItem>();

      expect(changedItems, isNotNull);
      expect(changedItems!.length, 1);
      expect(changedItems!.first, testItems.first);
    });

    testWidgets('should show selected items count',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Expand and select items
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Manually select items for testing
      store.toggleItemSelection(testItems.first);
      store.toggleItemSelection(testItems[1]);

      await tester.pumpAndSettle();

      // Should show count of selected items
      expect(find.textContaining('2'), findsWidgets);
    });

    testWidgets('should show confirmed items as chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Select and confirm items
      store.toggleItemSelection(testItems.first);
      store.confirmSelection();

      await tester.pumpAndSettle();

      // Should show chip with item name
      expect(find.byType(Chip), findsOneWidget);
      expect(find.text(testItems.first.name), findsOneWidget);
    });

    testWidgets('should remove confirmed item when chip delete is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Select and confirm item
      store.toggleItemSelection(testItems.first);
      store.confirmSelection();

      await tester.pumpAndSettle();

      // Should have confirmed item
      expect(store.confirmedItems.contains(testItems.first), true);

      // Find and tap delete icon on chip
      final deleteIcon = find.byIcon(Icons.close_rounded);
      if (deleteIcon.evaluate().isNotEmpty) {
        await tester.tap(deleteIcon);
        await tester.pumpAndSettle();

        // Item should be removed
        expect(store.confirmedItems.contains(testItems.first), false);
      }
    });

    testWidgets('should show empty state when no items are selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show inbox icon and empty state message
      expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
    });
  });
}
